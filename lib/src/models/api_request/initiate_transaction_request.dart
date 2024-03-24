class InitiateTransactionRequest {
  String publicKey;

  InitiateTransactionRequest({
    required this.publicKey,
  });

  factory InitiateTransactionRequest.fromJson(Map<String, dynamic> json) {
    return InitiateTransactionRequest(
      publicKey: json['publicKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicKey': publicKey,
    };
  }
}
