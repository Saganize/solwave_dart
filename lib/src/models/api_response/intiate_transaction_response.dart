class InitiateTransactionResponse {
  String idempotencyId;
  String authToken;
  String rsaPublicKey;
  String url;

  InitiateTransactionResponse({
    required this.idempotencyId,
    required this.authToken,
    required this.rsaPublicKey,
    required this.url,
  });

  factory InitiateTransactionResponse.fromJson(Map<String, dynamic> json) {
    return InitiateTransactionResponse(
      idempotencyId: json['idempotencyId'] ?? '',
      authToken: json['authToken'] ?? '',
      rsaPublicKey: json['rsaPublicKey'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idempotencyId': idempotencyId,
      'authToken': authToken,
      'rsaPublicKey': rsaPublicKey,
      'url': url,
    };
  }
}
