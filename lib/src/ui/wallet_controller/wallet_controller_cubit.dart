import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/wallet.dart';
import '../../core/solwave_error.dart';

import '../../repository/repository.dart';

class WalletControllerCubit extends Cubit<WalletFlowState> {
  WalletControllerCubit({this.selectionCallback})
      : super(WalletFlowLoadingState()) {
    initConnectivity();
    connection =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setWalletErrorFlow(
          SolwaveErrorCodes.noInternetConnection.message,
        );
      } else {
        if (state is WalletFlowErrorState) {
          emit(cachedState);
        }
      }
    });
  }

  Function(WalletEntity)? selectionCallback;
  late WalletFlowState cachedState;
  late StreamSubscription connection;
  final Connectivity _connectivity = Connectivity();

  @override
  void onChange(Change<WalletFlowState> change) {
    cachedState = state;
    super.onChange(change);
  }

  @override
  Future<void> close() {
    connection.cancel();
    return super.close();
  }

  void selectWalletCallback(WalletEntity wallet) {
    if (selectionCallback != null) {
      selectionCallback!(wallet);
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.wifi &&
          result != ConnectivityResult.mobile) {
        setWalletErrorFlow(
          SolwaveErrorCodes.noInternetConnection.message,
        );
      }
    } on PlatformException catch (_) {
      return;
    }
  }

  void setWalletAuthFlow() {
    emit(WalletFlowAuthState());
  }

  void setWalletTransactionFlow() {
    emit(WalletFlowTransactionState());
  }

  void setWalletSelectionFlow() {
    emit(WalletFlowSelectionState());
  }

  void setWalletErrorFlow(String errorMessage) {
    emit(WalletFlowErrorState(
      errorMessage: errorMessage,
    ));
  }

  void signMessageFlow() {
    emit(WalletFlowSignMessageState());
  }

  void forceCloseActivity({bool authFlow = false}) async {
    if (authFlow) {
      await Repository.instance.signOut();
    }
    emit(WalletFlowForceCloseActivity());
  }

  void closeActivity({String? message}) {
    emit(WalletFlowCloseActivity());
  }
}

abstract class WalletFlowState {}

class WalletFlowLoadingState extends WalletFlowState {}

class WalletFlowAuthState extends WalletFlowState {}

class WalletFlowSelectionState extends WalletFlowState {}

class WalletFlowTransactionState extends WalletFlowState {}

class WalletFlowSignMessageState extends WalletFlowState {}

class WalletFlowCloseActivity extends WalletFlowState {}

class WalletFlowForceCloseActivity extends WalletFlowState {}

class WalletFlowErrorState extends WalletFlowState {
  final String errorMessage;

  WalletFlowErrorState({
    required this.errorMessage,
  });
}
