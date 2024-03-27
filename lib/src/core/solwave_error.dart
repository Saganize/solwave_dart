// ignore_for_file: constant_identifier_names

import 'package:solwave_dart/src/models/base_response.dart';

class SolwaveError {
  final String status;
  final String message;

  SolwaveError({
    required this.status,
    required this.message,
  });

  static SolwaveError createError(SolwaveErrorCodes codes) {
    return SolwaveError(status: codes.status, message: codes.message);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
    };
  }

  factory SolwaveError.fromJson(Map<String, dynamic> map) {
    return SolwaveError(
      status: map['status'] as String,
      message: getStatusMessage(map['status']),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() => 'SolwaveError(status: $status, message: $message)';
}

enum SolwaveErrorCodes {
  firebaseError(firebaseAuth, FIREBASE_NOT_INITIALIZED),

  /// No internet connection message.
  noInternetConnection(noInternet, NO_INTERNET),

  /// Generic error message.
  genericError(genericErrorMsg, GENERIC_ERROR),

  /// Verification error message.
  verificationError(verificationFaild, VERIFICATION_FAILED),

  /// Insufficient funds error message.
  fundsError(lessBalance, LESS_BALANCE),

  /// Deep link error message.
  deepLinkError(deepLinkErrorMsg, DEEP_LINK_ERROR),

  /// Create user initialization error message.
  initCreateUserError(initCreateUserErrorMsg, INIT_CREATE_USER_ERROR),

  /// Login user initialization error message.
  initLoginUserError(initLoginUserErrorMsg, INIT_LOGIN_USER_ERROR),

  /// Webview error message.
  webviewError(webviewErrorMsg, WEBVIEW_ERROR),

  /// Initiate transaction error message.
  initiateTransactionError(
      initiateTransactionErrorMsg, INITIATE_TRANSACTION_ERROR),

  /// Invalid transaction message.
  invalidTransaction(invalidTransactionMsg, INVALID_TRANSACTION),

  /// No start event message.
  noStartEvent(noStartEventMsg, NO_START_EVENT),

  /// No API key passed message.
  noApiKeyPassed(noApiKeyPassedMsg, NO_API_KEY_PASSED),

  /// No transaction passed message.
  noTransactionPassed(noTransactionPassedMsg, NO_TRANSACTION_PASSED),

  /// No wallet selected message.
  noWalletSelected(noWalletSelectedMsg, NO_WALLET_SELECTED),

  /// User not found message.
  userNotFound(userNotFoundMsg, NO_USER_FOUND),

  /// Error in signing message
  initiateSignMessageError(signMessageError, SIGN_MESSAGE_ERROR);

  final String message;
  final String status;

  const SolwaveErrorCodes(this.status, this.message);
}

const String FIREBASE_NOT_INITIALIZED =
    'Firebase is not initialized. Please initialize Firebase before using the library.';
const String NO_INTERNET =
    'It looks like your device is offline. Please check your internet connection and try again.';
const String GENERIC_ERROR =
    'Something unexpected happened. Please try again later.';
const String VERIFICATION_FAILED =
    'Transaction signature verification failed. Please try again.';
const String LESS_BALANCE =
    'Sorry, we couldn\'t process your payment due to low wallet balance. Please add funds and try again.';
const String DEEP_LINK_ERROR =
    'We encountered an issue with the selected wallet app. Please try again.';

const String INIT_CREATE_USER_ERROR =
    'Unable to create user account at the moment. Please try again later.';
const String INIT_LOGIN_USER_ERROR =
    'Unable to login user at the moment. Please try again later.';
const String INITIATE_TRANSACTION_ERROR =
    'Unable to initiate transaction at the moment. Please try again later.';
const String WEBVIEW_ERROR = GENERIC_ERROR;
const String NO_START_EVENT = 'No start event found. Illegal state.';
const String NO_API_KEY_PASSED =
    'No API key passed. Please pass API key to use the library.';
const String NO_TRANSACTION_PASSED =
    'No transaction passed. Please pass transaction to use the function.';
const String INVALID_TRANSACTION =
    'Invalid transaction. Please pass a valid transaction.';
const String NO_WALLET_SELECTED =
    'No wallet selected. Please select a wallet to continue.';
const String NO_USER_FOUND = 'This user doesn\'t exist';
const String SIGN_MESSAGE_ERROR = 'There was an error signing message';

const String noInternet = 'NO_INTERNET';
const String genericErrorMsg = 'GENERIC_ERROR';
const String verificationFaild = 'VERIFICATION_FAILED';
const String lessBalance = 'LESS_BALANCE';
const String deepLinkErrorMsg = 'DEEP_LINK_ERROR';
const String initCreateUserErrorMsg = 'INIT_CREATE_USER_ERROR';
const String initLoginUserErrorMsg = 'INIT_LOGIN_USER_ERROR';
const String webviewErrorMsg = 'WEBVIEW_ERROR';
const String initiateTransactionErrorMsg = 'INITIATE_TRANSACTION_ERROR';
const String invalidTransactionMsg = 'INVALID_TRANSACTION';
const String noStartEventMsg = 'NO_START_EVENT';
const String noApiKeyPassedMsg = 'NO_API_KEY_PASSED';
const String noTransactionPassedMsg = 'NO_TRANSACTION_PASSED';
const String noWalletSelectedMsg = 'NO_WALLET_SELECTED';
const String userNotFoundMsg = 'NO_USER_FOUND';
const String firebaseAuth = "FIREBASE_AUTH_ERROR";
const String signMessageError = 'INITIATE_SIGN_MESSAGE_ERROR';
