import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/foundation.dart';

import '../../core/wallet_provider.dart';
import '../../models/wallet.dart';

class AvailableWallets {
  static final solwave = WalletEntity(
    walletProvider: WalletProvider.saganize,
  );

  static final otherWallets = [
    WalletEntity(
      walletProvider: WalletProvider.phantom,
    ),
    WalletEntity(
      walletProvider: WalletProvider.solflare,
    )
  ];

  static Future<void> checkAvailableWallets() async {
    try {
      AppInfo? solflareInstalled;
      AppInfo? phantomInstalled;

      if (Platform.isAndroid) {
        solflareInstalled =
            await AppCheck.checkAvailability('com.solflare.mobile');
        phantomInstalled = await AppCheck.checkAvailability('app.phantom');
      } else {
        solflareInstalled = await AppCheck.checkAvailability('phantom.app://');
        phantomInstalled = await AppCheck.checkAvailability('solflare.com://');
      }

      if (phantomInstalled != null) {
        otherWallets
            .removeWhere((e) => e.walletProvider == WalletProvider.phantom);
        otherWallets.add(
          WalletEntity(
            walletProvider: WalletProvider.phantom,
            available: true,
          ),
        );
      }

      if (solflareInstalled != null) {
        otherWallets
            .removeWhere((e) => e.walletProvider == WalletProvider.solflare);
        otherWallets.add(
          WalletEntity(
            walletProvider: WalletProvider.solflare,
            available: true,
          ),
        );
      }
    } catch (e) {
      debugPrint('AppAvaialibity Check $e');
    }
  }
}
