class SimulateTransactionResponse {
  String status;
  int type;
  String log;
  double networkFee;

  SimulateTransactionResponse({
    required this.status,
    required this.type,
    required this.log,
    required this.networkFee,
  });

  SimulateTransactionResponse copyWith({
    String? status,
    int? type,
    String? log,
    double? networkFee,
  }) {
    return SimulateTransactionResponse(
      status: status ?? this.status,
      type: type ?? this.type,
      log: log ?? this.log,
      networkFee: networkFee ?? this.networkFee,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'type': type,
      'log': log,
      'networkFee': networkFee,
    };
  }

  factory SimulateTransactionResponse.fromJson(Map<String, dynamic> map) {
    return SimulateTransactionResponse(
      status: map['status'] as String,
      type: map['type'] as int,
      log: map['log'] as String,
      networkFee: double.tryParse(map['networkFee']?.toString() ?? '0.0')!,
    );
  }

  @override
  String toString() {
    return 'SimulateTransactionResponse(status: $status, type: $type, log: $log,  networkFee: $networkFee)';
  }

  @override
  bool operator ==(covariant SimulateTransactionResponse other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.type == type &&
        other.log == log &&
        other.networkFee == networkFee;
  }

  @override
  int get hashCode {
    return status.hashCode ^ type.hashCode ^ log.hashCode ^ networkFee.hashCode;
  }
}
