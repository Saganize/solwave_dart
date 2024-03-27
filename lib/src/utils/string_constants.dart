class StringConstants {
  static const authScreenTitle = 'One account for \n secure transactions';
  static const authScreenSubtitle =
      'SAGAnize becomes a secure wallet that store \n all the funds for easy and safe transactions.';
  static const authScreenNewAccountTitle = 'Get Started';
  static const authScreenNewAccountSubtitle =
      'Just few easy steps to get you started';

  /// AuthView
  static const authScreenLoginTitle = 'Login';
  static const authScreenLoginSubtitle = 'Import your account safe and secure';

  static const authConnectEmail = 'Connect with your email address';
  static const authfooterText = ('Already have an account? ', 'LOGIN');

  static const walletSelectionScreenTitle =
      (recomended: 'RECOMMENED', otherWallets: 'OTHER WALLETS');

  static const selectionButtonCTA = 'SELECT';
  static const selectedButtonCTA = 'SELECTED';

  /// Transaction View
  static const transactionViewEstimatedCharged = (
    title: 'Estimated Charges',
    defaultBody:
        'Unable to simulate the transaction.  If you trust the app then only proceed.',
  );
  static const transactionWalletText = 'pay using';

  /// Sign Message view
  ///
  static const singMessageTitle = 'Message:';

  static const transactionViewLowBalance = (
    logo: '',
    title: 'Add funds to wallet',
    body: 'Your wallet is low on balance. Add some funds',
    buttonCTA: 'Continue'
  );

  static const userPublicKey = 'USER_PUBLIC_KEY';
  static const currentWallet = 'CURRENT_SELECTED_WALLET';
  static const sharedSecretKey = 'SHARED_SECRET_KEY';
  static const connectedWallets = 'CONNECTED_WALLETS';
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
