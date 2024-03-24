enum WalletProvider {
  saganize(
    host: 'saganize.com',
    package: 'solwave',
    logo: 'lib/assets/saganize.svg',
    title: 'Saganize',
    type: WalletType.saganize,
  ),

  phantom(
    host: 'phantom.app',
    package: 'phantom',
    title: 'Phantom',
    logo: 'lib/assets/phantom.svg',
    connectPath: '/ul/v1/connect',
    transactPath: '/ul/v1/signAndSendTransaction',
    signMessagePath: '/ul/v1/signMessage',
    encryptionKey: 'phantom_encryption_public_key',
    type: WalletType.otherProvider,
  ),

  solflare(
    host: 'solflare.com',
    package: 'solflare',
    title: 'Solflare',
    logo: 'lib/assets/solflare.svg',
    connectPath: '/ul/v1/connect',
    transactPath: '/ul/v1/signAndSendTransaction',
    signMessagePath: '/ul/v1/signMessage',
    encryptionKey: 'solflare_encryption_public_key',
    type: WalletType.otherProvider,
  );

  final String host;
  final String package;
  final String logo;
  final String title;
  final WalletType type;
  final String? connectPath;
  final String? transactPath;
  final String? signMessagePath;
  final String? encryptionKey;

  const WalletProvider({
    required this.host,
    required this.logo,
    required this.package,
    required this.title,
    required this.type,
    this.connectPath,
    this.transactPath,
    this.signMessagePath,
    this.encryptionKey,
  });

  static WalletProvider fromJson(String json) {
    return switch (json) {
      'solflare' => solflare,
      'phantom' => phantom,
      _ => saganize,
    };
  }

  String toJson() {
    return package;
  }
}

enum WalletType {
  saganize,
  otherProvider,
}
