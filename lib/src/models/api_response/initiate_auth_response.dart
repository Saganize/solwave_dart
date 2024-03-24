class InitiateAuthResponse {
  String userId;
  String authIdempotencyId;
  String accessToken;
  String rsaPublicKey;
  String url;
  String email;

  InitiateAuthResponse({
    required this.userId,
    required this.authIdempotencyId,
    required this.accessToken,
    required this.rsaPublicKey,
    required this.url,
    required this.email,
  });

  factory InitiateAuthResponse.fromJson(Map<String, dynamic> json) {
    return InitiateAuthResponse(
        userId: json['authIdempotencyId'] ?? '',
        authIdempotencyId: json['authIdempotencyId'] ?? '',
        accessToken: json['accessToken'] ?? '',
        rsaPublicKey: json['rsaPublicKey'] ?? '',
        url: json['url'] ?? '',
        email: json['email'] ?? '');
  }

  InitiateAuthResponse copyWith({
    String? userId,
    String? authIdempotencyId,
    String? accessToken,
    String? rsaPublicKey,
    String? url,
    String? email,
  }) {
    return InitiateAuthResponse(
      userId: userId ?? this.userId,
      authIdempotencyId: authIdempotencyId ?? this.authIdempotencyId,
      accessToken: accessToken ?? this.accessToken,
      rsaPublicKey: rsaPublicKey ?? this.rsaPublicKey,
      url: url ?? this.url,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'authIdempotencyId': authIdempotencyId,
      'accessToken': accessToken,
      'rsaPublicKey': rsaPublicKey,
      'url': url,
      'email': email,
    };
  }

  factory InitiateAuthResponse.fromMap(Map<String, dynamic> map) {
    return InitiateAuthResponse(
      userId: map['userId'] as String,
      authIdempotencyId: map['authIdempotencyId'] as String,
      accessToken: map['accessToken'] as String,
      rsaPublicKey: map['rsaPublicKey'] as String,
      url: map['url'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'InitiateAuthResponse(userId: $userId, authIdempotencyId: $authIdempotencyId, accessToken: $accessToken, rsaPublicKey: $rsaPublicKey, url: $url, email: $email)';
  }

  @override
  bool operator ==(covariant InitiateAuthResponse other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.authIdempotencyId == authIdempotencyId &&
        other.accessToken == accessToken &&
        other.rsaPublicKey == rsaPublicKey &&
        other.url == url &&
        other.email == email;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        authIdempotencyId.hashCode ^
        accessToken.hashCode ^
        rsaPublicKey.hashCode ^
        url.hashCode ^
        email.hashCode;
  }
}
