import 'package:flutter/foundation.dart';

import '../core/wallet_provider.dart';

class WalletEntity {
  final WalletProvider walletProvider;
  final String? publicAddress;
  final bool available;

  WalletEntity(
      {required this.walletProvider,
      this.publicAddress,
      this.available = false});

  WalletEntity copyWith({
    WalletProvider? walletProvider,
    String? publicAddress,
  }) {
    return WalletEntity(
      walletProvider: walletProvider ?? this.walletProvider,
      publicAddress: publicAddress ?? this.publicAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'walletProvider': walletProvider.toJson(),
      'publicAddress': publicAddress,
    };
  }

  factory WalletEntity.fromJson(Map<String, dynamic> map) {
    return WalletEntity(
      walletProvider: WalletProvider.fromJson(map['walletProvider']),
      publicAddress:
          map['publicAddress'] != null ? map['publicAddress'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Wallet(package: ${walletProvider.package}, logo: ${walletProvider.logo}, walletTitle: ${walletProvider.title}, publicAddress: $publicAddress)';
  }

  @override
  bool operator ==(covariant WalletEntity other) {
    if (identical(this, other)) return true;

    return other.walletProvider.package == walletProvider.package &&
        other.walletProvider.logo == walletProvider.logo &&
        other.walletProvider.title == walletProvider.title &&
        other.publicAddress == publicAddress;
  }

  @override
  int get hashCode {
    return walletProvider.package.hashCode ^
        walletProvider.logo.hashCode ^
        walletProvider.title.hashCode ^
        publicAddress.hashCode;
  }
}

class WalletProviderEntity extends WalletEntity {
  WalletProviderEntity({
    required super.walletProvider,
    required super.publicAddress,
    required this.session,
    required this.encryptionPublicKey,
  });

  final String session;
  final String encryptionPublicKey;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'walletProvider': walletProvider.toJson(),
      'publicAddress': publicAddress,
      'session': session,
      'encryptionPublicKey': encryptionPublicKey,
    };
  }

  factory WalletProviderEntity.fromJson(Map<String, dynamic> map) {
    return WalletProviderEntity(
      walletProvider: WalletProvider.fromJson(map['walletProvider']),
      publicAddress:
          map['publicAddress'] != null ? map['publicAddress'] as String : null,
      session: map['session'],
      encryptionPublicKey: map['encryptionPublicKey'],
    );
  }
}

class ConnectedWallets {
  final List<WalletEntity> connectedWallets;
  ConnectedWallets({
    required this.connectedWallets,
  });

  ConnectedWallets copyWith({
    List<WalletEntity>? connectedWallets,
  }) {
    return ConnectedWallets(
      connectedWallets: connectedWallets ?? this.connectedWallets,
    );
  }

  void addWallet(WalletEntity newWallet) {
    connectedWallets.map((e) {
      if (e.walletProvider == newWallet.walletProvider) {
        connectedWallets.remove(e);
      }
    });
    connectedWallets.add(newWallet);
  }

  WalletEntity? getMachingWallet(WalletProvider provider) {
    final result =
        connectedWallets.where((e) => e.walletProvider == provider).toList();
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'connectedWallets': connectedWallets.map((x) => x.toJson()).toList(),
    };
  }

  factory ConnectedWallets.fromJson(Map<String, dynamic> map) {
    List<WalletEntity> connectedWallets = [];

    map['connectedWallets'].forEach((e) {
      if (e['session'] != null) {
        connectedWallets.add(WalletProviderEntity.fromJson(e));
      } else {
        connectedWallets.add(WalletEntity.fromJson(e));
      }
    });

    return ConnectedWallets(
      connectedWallets: connectedWallets,
    );
  }

  @override
  String toString() => 'ConnectedWallets(connectedWallets: $connectedWallets)';

  @override
  bool operator ==(covariant ConnectedWallets other) {
    if (identical(this, other)) return true;

    return listEquals(other.connectedWallets, connectedWallets);
  }

  @override
  int get hashCode => connectedWallets.hashCode;
}
