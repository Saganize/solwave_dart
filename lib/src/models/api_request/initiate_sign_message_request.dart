class InitiateSignMessageRequest {
  final String publicKey;

  InitiateSignMessageRequest({required this.publicKey});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'publicKey': publicKey,
    };
  }

  factory InitiateSignMessageRequest.fromJson(Map<String, dynamic> map) {
    return InitiateSignMessageRequest(
      publicKey: map['publicKey'] as String,
    );
  }
}
