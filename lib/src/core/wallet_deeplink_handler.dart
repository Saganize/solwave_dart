import 'dart:convert';

import 'package:bs58/bs58.dart';
import 'package:pinenacl/x25519.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';
import '../repository/repository.dart';
import 'constants.dart';
import 'solwave_error.dart';
import 'wallet_provider.dart';

class WalletDeeplinkHandler {
  WalletDeeplinkHandler._();

  static final WalletDeeplinkHandler _instance = WalletDeeplinkHandler._();
  static WalletDeeplinkHandler get instance => _instance;

  final Repository repo = Repository.instance;

  void connectWallet(WalletProvider provider) async {
    final sk = PrivateKey.generate();
    final pk = sk.publicKey;
    await repo.saveKeypair(sk);

    Uri url = Uri(
      scheme: 'https',
      host: provider.host,
      path: provider.connectPath,
      queryParameters: {
        'dapp_encryption_public_key': base58.encode(pk.asTypedList),
        'cluster': SolanaRpc.devnet.cluster,
        'app_url': "https://saganize.com",
        'redirect_link': 'app://solwave.com/deeplink',
      },
    );

    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void signAndSendTransaction(
      WalletProviderEntity entity, Uint8List transaction) async {
    final key = await repo.getKeypair();
    final nonce = PineNaClUtils.randombytes(24);
    const encoder = JsonEncoder();

    final payload = {
      "transaction": base58.encode(transaction),
      "session": entity.session,
    };
    final sharedSecret = Box(
      myPrivateKey: key!,
      theirPublicKey: PublicKey(base58.decode(entity.encryptionPublicKey)),
    );

    final encryptedPayload = sharedSecret
        .encrypt(
          encoder.convert(payload).codeUnits.toUint8List(),
          nonce: nonce,
        )
        .cipherText;

    Uri url = Uri(
      scheme: 'https',
      host: entity.walletProvider.host,
      path: entity.walletProvider.transactPath,
      queryParameters: {
        'dapp_encryption_public_key': base58.encode(
          key.publicKey.asTypedList,
        ),
        'cluster': SolanaRpc.devnet.cluster,
        'app_url': "https://saganize.com",
        'redirect_link': 'app://solwave.com/deeplink',
        'nonce': base58.encode(nonce),
        'payload': base58.encode(encryptedPayload.asTypedList),
      },
    );

    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void signMessage(WalletProviderEntity entity, String message) async {
    final key = await repo.getKeypair();
    final nonce = PineNaClUtils.randombytes(24);
    const encoder = JsonEncoder();

    final payload = {
      "message": base58.encode(Uint8List.fromList(utf8.encode(message))),
      "session": entity.session,
      "display": "utf8"
    };
    final sharedSecret = Box(
      myPrivateKey: key!,
      theirPublicKey: PublicKey(base58.decode(entity.encryptionPublicKey)),
    );

    final encryptedPayload = sharedSecret
        .encrypt(
          encoder.convert(payload).codeUnits.toUint8List(),
          nonce: nonce,
        )
        .cipherText;

    Uri url = Uri(
      scheme: 'https',
      host: entity.walletProvider.host,
      path: entity.walletProvider.signMessagePath,
      queryParameters: {
        'dapp_encryption_public_key': base58.encode(
          key.publicKey.asTypedList,
        ),
        'cluster': SolanaRpc.devnet.cluster,
        'app_url': "https://saganize.com",
        'redirect_link': 'app://solwave.com/deeplink',
        'nonce': base58.encode(nonce),
        'payload': base58.encode(encryptedPayload.asTypedList),
      },
    );

    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<(WalletProviderEntity?, SolwaveError?)> parseConnectionDeeplink(
      String link, WalletProvider walletProvider) async {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    if (queryParams['errorCode'] != null) {
      final err = SolwaveError(
        status: SolwaveErrorCodes.deepLinkError.status,
        message: queryParams['errorMessage']!,
      );

      return (null, err);
    }

    final theirPublicKey =
        base58.decode(queryParams[walletProvider.encryptionKey]!);

    final key = await repo.getKeypair();
    final sharedSecret = Box(
      myPrivateKey: key!,
      theirPublicKey: PublicKey(theirPublicKey),
    );

    final decryptedData = sharedSecret.decrypt(
      ByteList(base58.decode(
        queryParams["data"]!,
      )),
      nonce: base58.decode(queryParams["nonce"]!),
    );

    final data =
        const JsonDecoder().convert(String.fromCharCodes(decryptedData));

    return (
      WalletProviderEntity(
        walletProvider: walletProvider,
        publicAddress: data['public_key'],
        session: data['session'],
        encryptionPublicKey: base58.encode(theirPublicKey),
      ),
      null
    );
  }

  Future<(String?, SolwaveError?)> parseTransactionDeeplink(
      String link, WalletProviderEntity entity) async {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    if (queryParams['errorCode'] != null) {
      final err = SolwaveError(
        status: SolwaveErrorCodes.deepLinkError.status,
        message: queryParams['errorMessage']!,
      );

      return (null, err);
    }

    final theirPublicKey = base58.decode(entity.encryptionPublicKey);

    final key = await repo.getKeypair();
    final sharedSecret = Box(
      myPrivateKey: key!,
      theirPublicKey: PublicKey(theirPublicKey),
    );

    final decryptedData = sharedSecret.decrypt(
      ByteList(base58.decode(
        queryParams["data"]!,
      )),
      nonce: base58.decode(queryParams["nonce"]!),
    );
    final data =
        const JsonDecoder().convert(String.fromCharCodes(decryptedData));
    final signature =
        data['signature'] != null ? data['signature'] as String : null;

    return (signature, null);
  }
}
