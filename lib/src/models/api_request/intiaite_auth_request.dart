class InitiateAuthRequest {
  String verifyToken;
  String email;

  InitiateAuthRequest({
    required this.verifyToken,
    required this.email,
  });

  InitiateAuthRequest.fromJson(Map<String, dynamic> json)
      : verifyToken = json['verifyToken'] ?? '',
        email = json['email'] ?? '';

  Map<String, dynamic> toJson() => {
        'verifyToken': verifyToken,
        'email': email,
      };
}
