import 'package:solana/solana.dart';

final SolanaClient _solanaRpc = SolanaClient(
  rpcUrl: Uri.parse('https://api.devnet.solana.com'),
  websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
);

Future<String> requestAirdrop(String pubKey) async {
  final result = await _solanaRpc.requestAirdrop(
    address: Ed25519HDPublicKey.fromBase58(pubKey),
    lamports: 1000000000,
  );

  return result;
}

Future<int> getBalance(String pubKey) async {
  final result = await _solanaRpc.rpcClient.getBalance(pubKey);
  return result.value;
}

String truncateString(String input) {
  if (input.length <= 10) {
    return input;
  }

  // Extract the first 5 characters
  String firstPart = input.substring(0, 4);

  // Extract the last 5 characters
  String lastPart = input.substring(input.length - 4);

  // Concatenate with dots in between
  return '$firstPart....$lastPart';
}
