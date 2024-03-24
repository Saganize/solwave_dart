class SimulateTransactionRequest {
  String transaction;
  String publicKey;

  SimulateTransactionRequest({
    required this.transaction,
    required this.publicKey,
  });

  factory SimulateTransactionRequest.fromJson(Map<String, dynamic> json) {
    return SimulateTransactionRequest(
      transaction: json['transaction'] ?? '',
      publicKey: json['publicKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction,
      'publicKey': publicKey,
    };
  }
}
