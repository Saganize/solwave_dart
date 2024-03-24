enum ApiPaths {
  initiateLogin(path: "solwave/auth/initiateLogin"),
  initiateAccountCreation(path: "solwave/auth/initiateCreateUser"),
  initiateTransaction(path: 'transaction/initiateTransaction'),
  simulateTransaction(path: 'transaction/simulate'),
  signMessage(path: 'transaction/initiateSignMessage');

  const ApiPaths({required this.path});
  final String path;
}

class ApiKeyConstants {
  static late String apiKey;
  static init(key) {
    apiKey = key;
  }
}

enum SolanaRpc {
  devnet(
    cluster: 'devnet',
    rpc: 'https://api.devnet.solana.com',
    wss: 'ws://api.devnet.solana.com',
  );

  final String rpc;
  final String wss;
  final String cluster;
  const SolanaRpc(
      {required this.rpc, required this.wss, required this.cluster});
}
