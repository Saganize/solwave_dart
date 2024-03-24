class WebViewActions {
  static const String getEmailAndPublicKey = 'getEmailAndPublicKey';
  static const String copyPublicKey = 'copyPublicKey';
  static const String showToast = 'showToast';
  static const String close = 'close';
  static const String transactionComplete = 'transactionComplete';
  static const String getTransaction = 'getTransaction';
  static const String getMessage = 'getMessage';
  static const String onMessageSigned = 'messageSigned';
}

class WebViewAction {
  String action;
  WebViewModel params;
  WebViewAction({
    required this.action,
    required this.params,
  });

  WebViewAction copyWith({
    String? action,
    WebViewModel? params,
  }) {
    return WebViewAction(
      action: action ?? this.action,
      params: params ?? this.params,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'action': action,
      'params': params.toJson(),
    };
  }

  factory WebViewAction.fromJson(Map<String, dynamic> map) {
    return WebViewAction(
      action: map['action'] as String,
      params: WebViewModel.fromJson(map['params']),
    );
  }

  @override
  String toString() => 'WebViewAction(action: $action, params: $params)';

  @override
  bool operator ==(covariant WebViewAction other) {
    if (identical(this, other)) return true;

    return other.action == action && other.params == params;
  }

  @override
  int get hashCode => action.hashCode ^ params.hashCode;
}

class WebViewModel {
  final String? email;
  final String? publicKey;
  final String? text;
  final WebViewClosingEvents? event;
  final String? message;
  final String? signature;
  final String? idempotencyId;
  WebViewModel({
    this.email,
    this.publicKey,
    this.text,
    this.event,
    this.message,
    this.signature,
    this.idempotencyId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'publicKey': publicKey,
      'text': text,
      'message': message,
      'signature': signature,
      'idempotencyId': idempotencyId,
    };
  }

  factory WebViewModel.fromJson(Map<String, dynamic> map) {
    return WebViewModel(
      email: map['email'] != null ? map['email'] as String : null,
      publicKey: map['publicKey'] != null ? map['publicKey'] as String : null,
      text: map['text'] != null ? map['text'] as String : null,
      event: map['event'] != null
          ? getWebViewClosingEvent(map['event'] as int)
          : null,
      message: map['message'] != null ? map['message'] as String : null,
      signature: map['signature'] != null ? map['signature'] as String : null,
      idempotencyId:
          map['idempotencyId'] != null ? map['idempotencyId'] as String : null,
    );
  }
}

enum WebViewClosingEvents {
  userCreationSuccess,
  loginSuccessful,
  transactionCompleted,
  userCreationFailure,
  loginFailure,
  serverError,
  transactionFailed,
  signingMessageSucces,
  signingMessageFailed;
}

getWebViewClosingEvent(int event) {
  return switch (event) {
    0 => WebViewClosingEvents.userCreationSuccess,
    1 => WebViewClosingEvents.loginSuccessful,
    2 => WebViewClosingEvents.transactionCompleted,
    3 => WebViewClosingEvents.userCreationFailure,
    4 => WebViewClosingEvents.loginFailure,
    6 => WebViewClosingEvents.transactionFailed,
    7 => WebViewClosingEvents.signingMessageSucces,
    9 => WebViewClosingEvents.signingMessageFailed,
    _ => WebViewClosingEvents.serverError,
  };
}
