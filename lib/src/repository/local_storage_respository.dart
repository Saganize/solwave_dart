import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/wallet.dart';
import '../utils/string_constants.dart';

class LocalStorageRepository {
  Database? db;
  final DatabaseFactory dbFactory = databaseFactoryIo;
  late final FlutterSecureStorage _secureStorage;
  final store = StoreRef.main();

  LocalStorageRepository() {
    init();
  }

  Future<Database> _getOrOpenDb() async {
    if (db == null) {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, 'solwave.db');
      db = await dbFactory.openDatabase(dbPath);
    }

    return db!;
  }

  Future<void> init() async {
    _secureStorage = const FlutterSecureStorage();
  }

  Future<bool> addWalletToStorage(WalletEntity wallet) async {
    await store
        .record(StringConstants.currentWallet)
        .put(await _getOrOpenDb(), wallet.toJson(), merge: true);
    return true;
  }

  Future<WalletEntity?> getCurrentWallet() async {
    final json = await store
        .record(StringConstants.currentWallet)
        .get(await _getOrOpenDb()) as Map<String, dynamic>?;
    if (json != null) {
      if (json['session'] != null) {
        return WalletProviderEntity.fromJson(json);
      }
      return WalletEntity.fromJson(json);
    }
    return null;
  }

  Future<bool> deleteWallet() async {
    try {
      await store
          .record(StringConstants.currentWallet)
          .delete(await _getOrOpenDb());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveKeypair(PrivateKey secretKey) async {
    await _secureStorage.write(
      key: StringConstants.sharedSecretKey,
      value: secretKey.encode(),
    );
    return true;
  }

  Future<PrivateKey?> getKeypair() async {
    final secretkey =
        await _secureStorage.read(key: StringConstants.sharedSecretKey);
    if (secretkey != null) {
      return PrivateKey.decode(secretkey);
    }
    return null;
  }

  Future<bool> saveConnectedWallets(ConnectedWallets wallets) async {
    await store.record(StringConstants.currentWallet).put(
          await _getOrOpenDb(),
          wallets.toJson(),
          merge: true,
        );
    return true;
  }

  Future<ConnectedWallets?> getConnectedWallets() async {
    final json = await store
        .record(StringConstants.currentWallet)
        .get(await _getOrOpenDb()) as Map<String, dynamic>?;
    if (json != null) {
      return ConnectedWallets.fromJson(json);
    }
    return null;
  }
}
