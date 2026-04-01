class DebtPayment {
  final int id;
  final int debtId;
  final double amount;
  final double remainingAfter;
  final String paidAt;

  const DebtPayment({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.remainingAfter,
    required this.paidAt,
  });

  factory DebtPayment.fromJson(Map<String, dynamic> json) => DebtPayment(
        id: (json['id'] as num).toInt(),
        debtId: (json['debtId'] as num).toInt(),
        amount: (json['amount'] as num).toDouble(),
        remainingAfter: (json['remainingAfter'] as num).toDouble(),
        paidAt: json['paidAt'] as String,
      );

  String get formattedDate {
    try {
      final dt = DateTime.parse(paidAt.replaceAll(' ', 'T'));
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$d/$m/${dt.year} à $h:$min';
    } catch (_) {
      return paidAt;
    }
  }

  bool get isFinal => remainingAfter <= 0;
}
