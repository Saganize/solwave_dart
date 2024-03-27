import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:uni_links/uni_links.dart';

import '../../../solwave_dart.dart';
import '../../core/constants.dart';
import '../../core/solwave_error.dart';
import '../../core/wallet_deeplink_handler.dart';
import '../../core/wallet_provider.dart';
import '../../models/api_request/initiate_transaction_request.dart';
import '../../models/api_request/simulate_transaction_request.dart';
import '../../repository/repository.dart';
import '../../utils/string_constants.dart';

class WalletTransactionCubit extends Cubit<WalletTransactionState> {
  WalletTransactionCubit({required this.tx, this.onTransacitonComplete})
      : super(WalletTransactionLoading()) {
    repo = Repository.instance;
    deeplinkHandler = WalletDeeplinkHandler.instance;
    initializeTx();
    initDeeplinkListner();
  }

  late Repository repo;
  late SolanaTransaction tx;
  late final WalletDeeplinkHandler deeplinkHandler;
  final Function(String signature, String? message)? onTransacitonComplete;

  Timer? _timer;
  int numberOfTries = 1;

  late final StreamSubscription? _sub;

  @override
  Future<void> close() {
    _timer?.cancel();
    _sub?.cancel();
    return super.close();
  }

  Future<void> initDeeplinkListner() async {
    _sub = linkStream.listen((String? link) async {
      if (state is WalletDeeplinkFlow && link != null) {
        final (singature, failure) =
            await deeplinkHandler.parseTransactionDeeplink(
          link,
          (state as WalletDeeplinkFlow).wallet,
        );
        if (failure != null) {
          emit(WalletTransactionError(
            error: failure.message,
          ));
        } else {
          updateSignatures([singature!]);
        }
      }
    }, onError: (err) {
      emit(WalletTransactionError(
        error: err.toString(),
      ));
    });
  }

  Uint8List compileMessageForTransaciton(
      SolanaTransaction transaction, String blockHash, String feePayer) {
    final message = Message(instructions: transaction.instructions);

    final compiledMessage = message.compileV0(
      recentBlockhash: blockHash,
      feePayer: Ed25519HDPublicKey.fromBase58(feePayer),
    );

    final tx = SignedTx(
      compiledMessage: compiledMessage,
      signatures: [
        Signature(
          List.filled(64, 0),
          publicKey: Ed25519HDPublicKey.fromBase58(feePayer),
        )
      ],
    ).encode();

    return Uint8List.fromList(base64Decode(tx));
  }

  void triggerTimer(
      {required WalletEntity wallet, required SolwaveTransaction tx}) {
    if (numberOfTries > 1) {
      int start = numberOfTries == 2 ? 3 : (5 * (numberOfTries - 1));
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (start == 0) {
            timer.cancel();
            emit(
              WalletLowFunds(
                tx: tx,
                wallet: wallet,
                countdown: null,
              ),
            );
          } else {
            emit(
              WalletLowFunds(
                tx: tx,
                wallet: wallet,
                countdown: start,
              ),
            );

            start--;
          }
        },
      );

      numberOfTries++;
    }
  }

  initializeTx() async {
    late SolwaveTransaction solwaveTx;
    final wallet = await repo.getCurrentWallet();
    if (isClosed) return;
    if (wallet == null) throw AssertionError('Wallet not selected or saved');
    final recentBlockHash =
        await repo.getLatestBlockHash(wallet.publicAddress!);
    final updatedTx =
        tx.copyWith(recentBlockHash: recentBlockHash?.value.blockhash ?? '');

    final instructions = tx.instructions;
    for (var i = 0; i < instructions.length; i++) {
      if (instructions[i].programId == SystemProgram.id) {
        final from = instructions[i].accounts[0].pubKey.toString();
        final to = instructions[i].accounts[1].pubKey.toString();

        final lamports = bytesToInt(
          instructions[i].data.toList(),
          SystemProgram.transferInstructionIndex.toList().length,
        );

        solwaveTx = SolwaveTransaction(
          type: SimulationType.transfer,
          data: TransactionPayload(
            from: from,
            lamports: lamports,
            to: to,
            transaction: updatedTx,
          ),
        );
      } else {
        solwaveTx = SolwaveTransaction(
          type: SimulationType.other,
          data: TransactionPayload(
            transaction: updatedTx,
          ),
        );
      }
    }

    final (sucess, _) = await repo.simulateTransaction(
      requestBody: SimulateTransactionRequest(
        transaction: jsonEncode(tx),
        publicKey: wallet.publicAddress!,
      ),
    );

    if (sucess != null) {
      final simulatedtx = solwaveTx.copyWith(
        data: solwaveTx.data.copyWith(
          fees: sucess.data!.networkFee,
        ),
      );

      final networkFeeText = switch (simulatedtx.data.fees) {
        < 0.0001 => '< 0.0001 SOL',
        0.0 => '< 0.0001 SOL',
        _ => '${sucess.data!.networkFee} SOL'
      };

      emit(
        WalletTransactionInitiated(
          tx: simulatedtx,
          networkFeeText: networkFeeText,
          networkFeeTitle: 'Network Fee:',
          wallet: wallet,
        ),
      );
    } else {
      emit(
        WalletTransactionInitiated(
          tx: solwaveTx,
          networkFeeTitle: 'Network Fee:',
          networkFeeText: '< 0.0001 SOL',
          wallet: wallet,
          txInfoBody:
              StringConstants.transactionViewEstimatedCharged.defaultBody,
        ),
      );
    }
  }

  void checkForBalance() async {
    if (state is WalletTransactionInitiated || state is WalletLowFunds) {
      // ignore: prefer_typing_uninitialized_variables
      var currentState;
      if (state is WalletTransactionInitiated) {
        currentState = state as WalletTransactionInitiated;
      } else {
        currentState = state as WalletLowFunds;
      }
      emit(WalletTransactionLoading());
      final balanceResult =
          await repo.getBalance(currentState.wallet.publicAddress!);

      if (balanceResult != null) {
        if (balanceResult.value < (currentState.tx.data.lamports ?? 1)) {
          if (numberOfTries > 1) {
            triggerTimer(
              wallet: currentState.wallet,
              tx: currentState.tx,
            );
          } else {
            emit(WalletLowFunds(
              tx: currentState.tx,
              wallet: currentState.wallet,
            ));

            numberOfTries++;
          }
        } else {
          if ((currentState.wallet as WalletEntity).walletProvider.type ==
              WalletType.otherProvider) {
            final tx = compileMessageForTransaciton(
              currentState.tx.data.transaction,
              currentState.tx.data.transaction.recentBlockHash,
              currentState.wallet.publicAddress,
            );

            deeplinkHandler.signAndSendTransaction(
              (currentState.wallet as WalletProviderEntity),
              tx,
            );

            emit(WalletDeeplinkFlow(wallet: currentState.wallet));
          } else {
            final (success, failure) = await repo.initiateTransaction(
                requestBody: InitiateTransactionRequest(
              publicKey: currentState.wallet.publicAddress!,
            ));

            if (success?.data != null) {
              final tempUrl =
                  'https://saganize-transaction-website-git-flutter-cdhiraj40.vercel.app/${success!.data?.idempotencyId}/transact';
              final webviewUrl =
                  '${tempUrl ?? success.data!.url}?access-token=${success.data!.authToken}&api-key=${ApiKeyConstants.apiKey}&platform=flutter';

              emit(WalletTransactionArppove(
                tx: currentState.tx,
                wallet: currentState.wallet,
                url: webviewUrl,
              ));
            } else {
              emit(WalletTransactionError(
                error: failure!.message,
              ));
            }
          }
        }
      } else {
        emit(WalletTransactionError(
          error: SolwaveError.createError(SolwaveErrorCodes.fundsError).message,
        ));
      }
    }
  }

  void updateSignatures(List<String> signatures) async {
    emit(WalletTransactionProcessing());

    if (onTransacitonComplete != null) {
      onTransacitonComplete!(signatures.first, null);
    }

    final status = await checkForSignatureStatuses(signatures, repo);

    if (status) {
      emit(WalletTransactionComplete(
          url:
              'https://explorer.solana.com/tx/${signatures.first}?cluster=${SolanaRpc.devnet.cluster}'));
    } else {
      emit(WalletTransactionFailure(
        failureMessage: SolwaveErrorCodes.verificationError.message,
      ));
    }
  }
}

abstract class WalletTransactionState {}

class WalletTransactionLoading extends WalletTransactionState {}

class WalletTransactionArppove extends WalletTransactionState {
  final SolwaveTransaction tx;
  final WalletEntity wallet;
  final String url;

  WalletTransactionArppove({
    required this.tx,
    required this.wallet,
    required this.url,
  });
}

class WalletTransactionInitiated extends WalletTransactionState {
  final String? txInfoBody;
  final String networkFeeTitle;
  final String networkFeeText;
  final SolwaveTransaction tx;
  final WalletEntity wallet;
  WalletTransactionInitiated({
    this.txInfoBody,
    required this.tx,
    required this.networkFeeText,
    required this.networkFeeTitle,
    required this.wallet,
  });
}

class WalletLowFunds extends WalletTransactionState {
  final SolwaveTransaction tx;
  final WalletEntity wallet;
  final int? countdown;
  WalletLowFunds({
    required this.tx,
    required this.wallet,
    this.countdown,
  });
}

class WalletTransactionProcessing extends WalletTransactionState {}

class WalletTransactionProcessed extends WalletTransactionState {}

class WalletTransactionComplete extends WalletTransactionState {
  String url;
  WalletTransactionComplete({
    required this.url,
  });
}

class WalletTransactionFailure extends WalletTransactionState {
  final String failureMessage;
  WalletTransactionFailure({required this.failureMessage});
}

class WalletTransactionError extends WalletTransactionState {
  final String error;
  WalletTransactionError({required this.error});
}

class WalletDeeplinkFlow extends WalletTransactionState {
  final WalletProviderEntity wallet;

  WalletDeeplinkFlow({required this.wallet});
}
