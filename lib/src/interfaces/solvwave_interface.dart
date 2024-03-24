import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import '../models/wallet.dart';

import '../models/solwave_transaction.dart';

abstract class SolwaveInterface {
  void selectWallet(BuildContext context) {
    throw UnimplementedError('selectWallet is not implemented');
  }

  void sendTransaction(BuildContext context,
      {required SolanaTransaction transaction}) {
    throw UnimplementedError('sendTransaction is not implemented');
  }

  void signMessage(BuildContext context, {required String message}) {
    throw UnimplementedError('signMessage is not implemented');
  }

  Future<WalletEntity?> getUserWallet() async {
    throw UnimplementedError('getUserKey is not implemented');
  }

  bool verifySignature(
      Uint8List signature, Uint8List messageBytes, Uint8List publicKey) {
    throw UnimplementedError('verifySignature is not implemented');
  }
}
