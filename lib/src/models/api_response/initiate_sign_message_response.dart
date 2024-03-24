class InitiateSignMessageResponse {
  final String idempotencyId;
  final String authToken;
  final String rsaPublicKey;
  final String url;

  InitiateSignMessageResponse(
      {required this.idempotencyId,
      required this.authToken,
      required this.rsaPublicKey,
      required this.url});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idempotencyId': idempotencyId,
      'authToken': authToken,
      'rsaPublicKey': rsaPublicKey,
      'url': url,
    };
  }

  factory InitiateSignMessageResponse.fromJson(Map<String, dynamic> map) {
    return InitiateSignMessageResponse(
      idempotencyId: map['idempotencyId'] as String,
      authToken: map['authToken'] as String,
      rsaPublicKey: map['rsaPublicKey'] as String,
      url: map['url'] as String,
    );
  }
}
