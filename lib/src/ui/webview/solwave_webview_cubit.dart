import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../solwave_dart.dart';
import '../../core/wallet_provider.dart';
import '../../repository/repository.dart';

class SolwaveWebViewCubit extends Cubit<SolWaveWebViewState> {
  SolwaveWebViewCubit({this.transaction, this.message})
      : super(WebViewEventPending()) {
    repo = Repository.instance;
  }

  late final Repository repo;
  Function(List<String> singatures)? onTransactionCompleteAction;
  SolwaveTransaction? transaction;
  String? message;

  Future<void> saveWallet(String publicKey) async {
    final wallet = WalletEntity(
      walletProvider: WalletProvider.saganize,
      publicAddress: publicKey,
    );
    ConnectedWallets? connectedWallets = await repo.getConnectedWallets();
    if (connectedWallets != null) {
      connectedWallets.addWallet(wallet);
    } else {
      connectedWallets = ConnectedWallets(connectedWallets: [wallet]);
    }
    await repo.saveConnectedWallets(connectedWallets);
    final result = await repo.addCurrentWallet(wallet: wallet);
    if (result) {
      emit(WebViewWalletSaved(
        currentWallet: wallet,
      ));
    }
  }

  void emiTransactionCallback(String signature) {
    emit(WebViewTransactionSuccessful(
      signatures: [signature],
    ));
  }

  void emiSignMessageCallback(String signature) {
    emit(WebViewSignMessageSuccessful(
      signatures: [signature],
    ));
  }

  void setLoading() {
    emit(WebViewLoading());
  }

  void setLoadend() {
    emit(WebViewLoaded());
  }
}

abstract class SolWaveWebViewState {}

class WebViewEventPending extends SolWaveWebViewState {}

class WebViewLoading extends SolWaveWebViewState {}

class WebViewLoaded extends SolWaveWebViewState {}

class WebViewEvent extends SolWaveWebViewState {}

class WebViewWalletSaved extends SolWaveWebViewState {
  final WalletEntity currentWallet;

  WebViewWalletSaved({required this.currentWallet});
}

class WebViewTransactionSuccessful extends SolWaveWebViewState {
  final List<String> signatures;

  WebViewTransactionSuccessful({required this.signatures});
}

class WebViewSignMessageSuccessful extends SolWaveWebViewState {
  final List<String> signatures;

  WebViewSignMessageSuccessful({required this.signatures});
}
