import 'package:solana/encoder.dart';

class SolwaveTransaction {
  TransactionPayload data;
  SolwaveTransactionStatus? status;
  SimulationType? type;

  SolwaveTransaction({
    required this.data,
    this.status,
    this.type,
  });

  get isTransferInstruction =>
      data.from != null && data.to != null && data.lamports != null;

  // factory SolwaveTransaction.fromJson(Map<String, dynamic> json) {
  //   return SolwaveTransaction(
  //     data: TransactionPayload.fromJson(json['data']),
  //     status: json['status'],
  //     type: json['type'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'status': status?.toJson(),
      'type': type?.toJson(),
    };
  }

  SolwaveTransaction copyWith({
    TransactionPayload? data,
    SolwaveTransactionStatus? status,
    SimulationType? type,
  }) {
    return SolwaveTransaction(
      data: data ?? this.data,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

class TransactionPayload {
  double fees;
  String? from;
  int? lamports;
  String? to;
  SolanaTransaction transaction;

  TransactionPayload({
    this.fees = 0.0,
    this.from,
    this.lamports,
    this.to,
    required this.transaction,
  });

  // factory TransactionPayload.fromJson(Map<String, dynamic> json) {
  //   return TransactionPayload(
  //     fees: json['fees'],
  //     from: json['from'],
  //     lamports: json['lamports'],
  //     to: json['to'],
  //     transaction: SolanaTransaction.fromJson(json['transaction']),
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'fees': fees,
      'from': from,
      'lamports': lamports,
      'to': to,
      'transaction': transaction.toJson(),
    };
  }

  TransactionPayload copyWith({
    double? fees,
    String? from,
    int? lamports,
    String? to,
    SolanaTransaction? transaction,
  }) {
    return TransactionPayload(
      fees: fees ?? this.fees,
      from: from ?? this.from,
      lamports: lamports ?? this.lamports,
      to: to ?? this.to,
      transaction: transaction ?? this.transaction,
    );
  }
}

class SolanaTransaction {
  String? recentBlockHash;
  List<Instruction> instructions;
  List<String>? signatures;

  SolanaTransaction({
    required this.instructions,
    this.recentBlockHash,
    this.signatures = const [],
  });

  // factory SolanaTransaction.fromJson(Map<String, dynamic> json) {
  //   return SolanaTransaction(
  //     instructions: (json['instructions'] as List)
  //         .map((instruction) => SolanaInstruction.fromJson(instruction))
  //         .toList(),
  //     signatures: List<String>.from(json['signatures']),
  //     recentBlockHash: json['recentBlockHash'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'instructions':
          instructions.map((instruction) => instruction.toJson()).toList(),
      'recentBlockHash': recentBlockHash,
      'signatures': signatures,
    };
  }

  SolanaTransaction copyWith({
    String? recentBlockHash,
    List<Instruction>? instructions,
    List<String>? signatures,
  }) {
    return SolanaTransaction(
      recentBlockHash: recentBlockHash ?? this.recentBlockHash,
      instructions: instructions ?? this.instructions,
      signatures: signatures ?? this.signatures,
    );
  }
}

// class SolanaInstruction {
//   ByteArray data;
//   List<AccountKey> keys;
//   String programId;

//   SolanaInstruction({
//     required this.data,
//     required this.keys,
//     required this.programId,
//   });

//   factory SolanaInstruction.fromJson(Map<String, dynamic> json) {
//     return SolanaInstruction(
//       data: ByteArray.fromString(json['data']),
//       keys: (json['keys'] as List)
//           .map((key) => AccountKey.fromJson(key))
//           .toList(),
//       programId: json['programId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.toList(),
//       'keys': keys.map((key) => key.toJson()).toList(),
//       'programId': programId,
//     };
//   }

//   SolanaInstruction copyWith({
//     ByteArray? data,
//     List<AccountKey>? keys,
//     String? programId,
//   }) {
//     return SolanaInstruction(
//       data: data ?? this.data,
//       keys: keys ?? this.keys,
//       programId: programId ?? this.programId,
//     );
//   }

//   @override
//   bool operator ==(covariant SolanaInstruction other) {
//     if (identical(this, other)) return true;

//     return other.data == data &&
//         listEquals(other.keys, keys) &&
//         other.programId == programId;
//   }

//   @override
//   int get hashCode => data.hashCode ^ keys.hashCode ^ programId.hashCode;
// }

// class AccountKey {
//   bool isSigner;
//   bool isWritable;
//   String pubkey;

//   AccountKey({
//     required this.isSigner,
//     this.isWritable = true,
//     required this.pubkey,
//   });

//   factory AccountKey.fromJson(Map<String, dynamic> json) {
//     return AccountKey(
//       isSigner: json['isSigner'],
//       isWritable: json['isWritable'],
//       pubkey: json['pubkey'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'isSigner': isSigner,
//       'isWritable': isWritable,
//       'pubkey': pubkey,
//     };
//   }
// }

// class PublicKey {
//   List<int> pubkey;

//   PublicKey({
//     required this.pubkey,
//   });

//   factory PublicKey.fromJson(Map<String, dynamic> json) {
//     return PublicKey(
//       pubkey: List<int>.from(json['pubkey']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'pubkey': pubkey,
//     };
//   }
// }

enum SimulationType {
  transfer(name: 'transfer'),
  other(name: 'other');

  const SimulationType({required this.name});

  final String name;

  String toJson() => name;

  static SimulationType fromJson(String json) {
    return SimulationType.values.firstWhere(
      (element) => element.name.toLowerCase() == json.toLowerCase(),
      orElse: () => transfer,
    );
  }
}

enum SolwaveTransactionStatus {
  success(value: 'success'),
  failed(value: 'failed');

  const SolwaveTransactionStatus({required this.value});

  final String value;

  String toJson() => value;
}

class SolwaveTransactionStringify {
  TransactionPayloadStringify data;
  SolwaveTransactionStatus? status;
  SimulationType? type;

  SolwaveTransactionStringify({
    required this.data,
    this.status,
    this.type,
  });

  get isTransferInstruction =>
      data.from != null && data.to != null && data.lamports != null;

  factory SolwaveTransactionStringify.fromJson(Map<String, dynamic> json) {
    return SolwaveTransactionStringify(
      data: TransactionPayloadStringify.fromJson(json['data']),
      status: json['status'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'status': status?.toJson(),
      'type': type?.toJson(),
    };
  }

  SolwaveTransactionStringify copyWith({
    TransactionPayloadStringify? data,
    SolwaveTransactionStatus? status,
    SimulationType? type,
  }) {
    return SolwaveTransactionStringify(
      data: data ?? this.data,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

class TransactionPayloadStringify {
  double fees;
  String? from;
  int? lamports;
  String? to;
  String transaction;

  TransactionPayloadStringify({
    this.fees = 0.0,
    this.from,
    this.lamports,
    this.to,
    required this.transaction,
  });

  factory TransactionPayloadStringify.fromJson(Map<String, dynamic> json) {
    return TransactionPayloadStringify(
      fees: json['fees'],
      from: json['from'],
      lamports: json['lamports'],
      to: json['to'],
      transaction: json['transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fees': fees,
      'from': from,
      'lamports': lamports,
      'to': to,
      'transaction': transaction,
    };
  }

  TransactionPayloadStringify copyWith({
    double? fees,
    String? from,
    int? lamports,
    String? to,
    String? transaction,
  }) {
    return TransactionPayloadStringify(
      fees: fees ?? this.fees,
      from: from ?? this.from,
      lamports: lamports ?? this.lamports,
      to: to ?? this.to,
      transaction: transaction ?? this.transaction,
    );
  }
}

extension InstructionJson on Instruction {
  Map<String, dynamic> toJson() {
    return {
      'programId': programId.toString(),
      'data': data.toList(),
      'keys': accounts.map((key) => key.toJson()).toList()
    };
  }
}

extension AccountMetaJson on AccountMeta {
  Map<String, dynamic> toJson() {
    return {
      'isSigner': isSigner,
      'isWritable': isWriteable,
      'pubkey': pubKey.toString(),
    };
  }
}
