class GetWalletResponse {
  double balance;

  GetWalletResponse({
    required this.balance,
  });

  factory GetWalletResponse.fromJson(Map<String, dynamic> json) {
    return GetWalletResponse(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
    };
  }
}
