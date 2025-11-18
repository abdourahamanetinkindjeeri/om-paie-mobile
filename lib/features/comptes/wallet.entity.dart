// class Wallet {
//   final String id;
//   final double balance;
//   final String currency;
//   final String userId;
//   final String? merchantId;
//   final DateTime updatedAt;
//   final DateTime createdAt;
//   // final bool isMain;

//   const Wallet({
//     required this.id,
//     required this.balance,
//     required this.currency,
//     required this.userId,
//     this.merchantId,
//     required this.updatedAt,
//     required this.createdAt,
//     // required this.isMain,
//   });

//   factory Wallet.fromJson(Map<String, dynamic> json) {
//     return Wallet(
//       id: (json['id'] ?? json['_id'] ?? '').toString(),
//       balance: (json['balance'] as num).toDouble(),
//       currency: json['currency'] as String,
//       userId: (json['userid'] ?? '').toString(),
//       merchantId: json['merchant_id'] as String?,
//       updatedAt: DateTime.parse(json['updated_at']),
//       createdAt: DateTime.parse(json['created_at']),
//       // isMain: json['is_main'] as bool,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'balance': balance,
//       'currency': currency,
//       'userid': userId,
//       'merchant_id': merchantId,
//       'updated_at': updatedAt.toIso8601String(),
//       'created_at': createdAt.toIso8601String(),
//       // 'is_main': isMain,
//     };
//   }
// }
