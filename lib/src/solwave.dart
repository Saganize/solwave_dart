import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:solwave/solwave.dart';

import 'core/constants.dart';
import 'core/solwave_view_type.dart';
import 'interfaces/solvwave_interface.dart';
import 'repository/repository.dart';
import 'ui/wallet_bottom_sheet.dart';
import 'ui/wallet_selection/available_wallets.dart';
import 'utils/size_util.dart';

class Solwave implements SolwaveInterface {
  late final String apiKey;
  Solwave._();

  static final Solwave _instance = Solwave._();
  static Solwave get instance => _instance;

  void init({required String apiKey}) async {
    this.apiKey = apiKey;
    ApiKeyConstants.init(apiKey);
    Repository.instance;
    await AvailableWallets.checkAvailableWallets();
  }

  @override
  Future<WalletEntity?> getUserWallet() async {
    return Repository.instance.getCurrentWallet();
  }

  @override
  void selectWallet(
    BuildContext context, {
    Function(WalletEntity)? onWalletSelection,
  }) {
    SizeUtil.init(context);
    SolwaveBottomSheet.openBottomSheet(
      context,
      type: SolwaveViewType.selectWallet,
      onWalletSelection: onWalletSelection,
    );
  }

  @override
  void sendTransaction(
    BuildContext context, {
    required SolanaTransaction transaction,
    Function(String signature)? onTransacitonComplete,
  }) {
    SizeUtil.init(context);
    SolwaveBottomSheet.openBottomSheet(
      context,
      type: SolwaveViewType.transact,
      tx: transaction,
      onTransacitonComplete: (signature, _) {
        if (onTransacitonComplete != null) onTransacitonComplete(signature);
      },
    );
  }

  @override
  void signMessage(
    BuildContext context, {
    required String message,
    Function(String signature, String message)? onMessageSigned,
  }) {
    SizeUtil.init(context);
    SolwaveBottomSheet.openBottomSheet(
      context,
      type: SolwaveViewType.signMessage,
      message: message,
      onTransacitonComplete: (signature, message) {
        if (onMessageSigned != null) onMessageSigned(signature, message!);
      },
    );
  }

  @override
  bool verifySignature(
      Uint8List signature, Uint8List messageBytes, Uint8List publicKey) {
    return verifySolwaveSignature(signature, messageBytes, publicKey);
  }
}
