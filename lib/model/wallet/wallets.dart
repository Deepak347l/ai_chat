class WalletModel {
  final String id;
  final double totalEarning;
  final double currentBalance;

  WalletModel({
    required this.id,
    required this.totalEarning,
    required this.currentBalance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      totalEarning: (json['totalEarning'] ?? 0).toDouble(),
      currentBalance: (json['currentBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalEarning': totalEarning,
      'currentBalance': currentBalance,
    };
  }
}