import 'package:bs58/bs58.dart';

import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/tweetnacl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solana/dto.dart';
import 'package:solwave_dart/src/repository/repository.dart';
import 'package:url_launcher/url_launcher.dart';

List<int> intToBytes(int data, {Endian endian = Endian.little}) {
  ByteData byteData = ByteData(4);
  byteData.setInt32(0, data, Endian.little);
  return byteData.buffer.asUint8List();
}

int bytesToInt(List<int> bytes, int startIndex,
    {Endian endian = Endian.little}) {
  List<int> numberBytes = bytes.sublist(startIndex);
  ByteData byteData = ByteData.view(Uint8List.fromList(numberBytes).buffer);
  return byteData.getInt32(0, endian);
}

List<int> addressBytes(String pubKey) {
  final List<int> byteList = base58.decode(pubKey).toList();
  return byteList;
}

String toBase58Address(List<int> bytes) {
  final String base58String = base58.encode(Uint8List.fromList(bytes));
  return base58String;
}

double lamportsToSol(int lamports) {
  return (lamports / 1000000000);
}

String replaceBackslashes(String input) {
  return input.replaceAll(r'\\\', r'\');
}

void launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

void shareMessage(String message) {
  Share.share(message);
}

const maxMessageLength = 200;

Future<bool> checkForSignatureStatuses(
    List<String> signatures, Repository repo) async {
  bool isConfirmed = false;
  for (int i = 0; i < 20; i++) {
    SignatureStatusesResult? result =
        await repo.getSignatureStatuses(signatures);

    if (result != null) {
      for (var status in result.value) {
        if (status?.confirmationStatus == Commitment.finalized) {
          isConfirmed = true;
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    if (isConfirmed) {
      break;
    }
  }

  return isConfirmed;
}

bool verifySolwaveSignature(
    Uint8List signature, Uint8List messageBytes, Uint8List publicKey) {
  if (signature.length != 64 || publicKey.length != 32) return false;

  final sm = (signature + messageBytes).toUint8List();
  final m = Uint8List(sm.length);

  final pk = publicKey;
  final verification = TweetNaCl.crypto_sign_open(m, -1, sm, 0, sm.length, pk);
  return verification >= 0;
}
