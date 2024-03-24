import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:uni_links/uni_links.dart';

import '../../core/wallet_deeplink_handler.dart';
import '../../core/wallet_provider.dart';
import '../../models/wallet.dart';
import '../../repository/repository.dart';

class WalletSelectionCubit extends Cubit<WalletSelectionState> {
  WalletSelectionCubit() : super(WalletSelectionLoading()) {
    repo = Repository.instance;
    deeplinkHandler = WalletDeeplinkHandler.instance;
    getUserPublicKey();
    initDeeplinkListner();
  }
  late final Repository repo;
  late final WalletDeeplinkHandler deeplinkHandler;
  late final StreamSubscription? _sub;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> initDeeplinkListner() async {
    _sub = linkStream.listen((String? link) async {
      if (state is WalletDeeplinkFlow && link != null) {
        final (wallet, failure) = await deeplinkHandler.parseConnectionDeeplink(
          link,
          (state as WalletDeeplinkFlow).provider,
        );
        if (failure != null) {
          emit(WalletSelectionError(
            failure.message,
          ));
        } else {
          await saveWallet(wallet!);
          emit(WalletSelected(wallet));
        }
      }
    }, onError: (err) {
      emit(WalletSelectionError(
        err.toString(),
      ));
    });
  }

  Future<void> getUserPublicKey() async {
    final wallet = await repo.getCurrentWallet();

    if (wallet != null) {
      emit(WalletSelected(wallet));
    } else {
      emit(WalletNotSelected());
    }
  }

  void selectWallet() async {
    if (!isClosed) {
      if (!(await checkConnectedWallets(WalletProvider.saganize))) {
        emit(WalletAuthFlow());
      }
    }
  }

  Future<void> saveWallet(WalletEntity wallet) async {
    ConnectedWallets? connectedWallets = await repo.getConnectedWallets();
    if (connectedWallets != null) {
      connectedWallets.addWallet(wallet);
    } else {
      connectedWallets = ConnectedWallets(connectedWallets: [wallet]);
    }
    await repo.addCurrentWallet(wallet: wallet);
    await repo.saveConnectedWallets(connectedWallets);
  }

  Future<bool> checkConnectedWallets(WalletProvider provider) async {
    final connectedWallets = await repo.getConnectedWallets();
    if (connectedWallets != null) {
      final wallet = connectedWallets.getMachingWallet(provider);
      if (wallet != null) {
        await repo.addCurrentWallet(wallet: wallet);
        emit(WalletSelected(wallet));
        return true;
      }
    }
    return false;
  }

  void selectWalletprovider(WalletProvider provider) async {
    if (!(await checkConnectedWallets(provider))) {
      emit(WalletDeeplinkFlow(provider: provider));
      deeplinkHandler.connectWallet(provider);
    }
  }
}

abstract class WalletSelectionState {}

class WalletSelectionLoading extends WalletSelectionState {}

class WalletNotSelected extends WalletSelectionState {}

class WalletAuthFlow extends WalletSelectionState {}

class WalletDeeplinkFlow extends WalletSelectionState {
  WalletProvider provider;
  WalletDeeplinkFlow({
    required this.provider,
  });
}

class WalletSelected extends WalletSelectionState {
  WalletEntity currentWallet;
  WalletSelected(this.currentWallet);
}

class WalletSelectionError extends WalletSelectionState {
  String error;
  WalletSelectionError(this.error);
}
