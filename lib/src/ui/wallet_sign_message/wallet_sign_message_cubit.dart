import 'dart:async';
import 'dart:convert';

import 'package:bs58/bs58.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinenacl/ed25519.dart';

import 'package:solana/base58.dart';
import '../../core/wallet_provider.dart';
import '../../models/api_request/initiate_sign_message_request.dart';

import '../../repository/repository.dart';
import 'package:uni_links/uni_links.dart';

import '../../../solwave.dart';
import '../../core/constants.dart';
import '../../core/solwave_error.dart';
import '../../core/wallet_deeplink_handler.dart';

class WalletSignMessageCubit extends Cubit<WalletSignMessageState> {
  WalletSignMessageCubit({required this.message, this.onTransacitonComplete})
      : super(WalletSignMessageLoading()) {
    repo = Repository.instance;
    deeplinkHandler = WalletDeeplinkHandler.instance;
    initSignMessage();
    initDeeplinkListner();
  }
  final Function(String signature, String? message)? onTransacitonComplete;
  late final StreamSubscription? _sub;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  final String message;
  late final Repository repo;
  late final WalletDeeplinkHandler deeplinkHandler;

  Future<void> initDeeplinkListner() async {
    _sub = linkStream.listen((String? link) async {
      if (state is WalletDeeplinkFlow && link != null) {
        final (singature, failure) =
            await deeplinkHandler.parseTransactionDeeplink(
          link,
          (state as WalletDeeplinkFlow).wallet,
        );
        if (failure != null) {
          emit(WalletSignMessageError(
            error: failure.message,
          ));
        } else {
          updateSignatures([singature!]);
        }
      }
    }, onError: (err) {
      emit(WalletSignMessageError(
        error: err.toString(),
      ));
    });
  }

  void initSignMessage() async {
    final wallet = await repo.getCurrentWallet();
    if (wallet == null) throw AssertionError('Wallet not selected or saved');
    final modifiedMessage = message.length >= maxMessageLength
        ? message.substring(0, maxMessageLength)
        : message;

    emit(WalletSignMessageInit(
      message: modifiedMessage,
      wallet: wallet,
    ));
  }

  void signMessage() async {
    if (state is WalletSignMessageInit) {
      final current = state as WalletSignMessageInit;

      if (current.wallet.walletProvider.type == WalletType.otherProvider) {
        deeplinkHandler.signMessage(
          (current.wallet as WalletProviderEntity),
          message,
        );

        emit(
            WalletDeeplinkFlow(wallet: current.wallet as WalletProviderEntity));
      } else {
        emit(WalletSignMessageLoading());
        final (success, failure) = await repo.signMessage(
          requestBody: InitiateSignMessageRequest(
            publicKey: current.wallet.publicAddress!,
          ),
        );

        if (success != null && success.data != null) {
          final tempUrl =
              'https://saganize-transaction-website-git-flutter-cdhiraj40.vercel.app/${success.data?.idempotencyId}/transact';
          final webviewUrl =
              '${tempUrl ?? success.data!.url}?access-token=${success.data!.authToken}&api-key=${ApiKeyConstants.apiKey}&platform=flutter';
          emit(
            WalletSignMessageSign(
              wallet: current.wallet,
              message: current.message,
              url: webviewUrl,
            ),
          );
        } else {
          emit(WalletSignMessageError(
            error: failure!.message,
          ));
        }
      }
    }
  }

  void updateSignatures(List<String> signatures) async {
    emit(WalletSignMessageProcessing());
    final wallet = await repo.getCurrentWallet();
    final status = verifySolwaveSignature(
      base58.decode(signatures.first),
      utf8.encode(message),
      base58decode(wallet!.publicAddress!).toUint8List(),
    );

    if (onTransacitonComplete != null) {
      onTransacitonComplete!(signatures.first, message);
    }

    if (status) {
      emit(WalletSignMessageClose());
    } else {
      emit(WalletSignMessageFailure(
        failureMessage: SolwaveErrorCodes.verificationError.message,
      ));
    }
  }
}

sealed class WalletSignMessageState {}

class WalletSignMessageInit extends WalletSignMessageState {
  final String message;
  final WalletEntity wallet;

  WalletSignMessageInit({
    required this.message,
    required this.wallet,
  });
}

class WalletSignMessageSign extends WalletSignMessageState {
  final String message;
  final WalletEntity wallet;
  final String url;

  WalletSignMessageSign({
    required this.message,
    required this.wallet,
    required this.url,
  });
}

class WalletSignMessageLoading extends WalletSignMessageState {}

class WalletSignMessageProcessing extends WalletSignMessageState {}

class WalletSignMessageComplete extends WalletSignMessageState {
  String url;
  WalletSignMessageComplete({
    required this.url,
  });
}

class WalletSignMessageFailure extends WalletSignMessageState {
  final String failureMessage;
  WalletSignMessageFailure({required this.failureMessage});
}

class WalletSignMessageError extends WalletSignMessageState {
  final String error;

  WalletSignMessageError({required this.error});
}

class WalletSignMessageClose extends WalletSignMessageState {
  WalletSignMessageClose();
}

class WalletDeeplinkFlow extends WalletSignMessageState {
  final WalletProviderEntity wallet;

  WalletDeeplinkFlow({required this.wallet});
}
