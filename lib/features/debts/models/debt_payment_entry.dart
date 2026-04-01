class DebtPaymentEntry {
  final String debtId;
  final double amountPaid;
  final double remainingAfter;
  final DateTime paidAt;
  final bool isFinal;

  const DebtPaymentEntry({
    required this.debtId,
    required this.amountPaid,
    required this.remainingAfter,
    required this.paidAt,
    this.isFinal = false,
  });

  Map<String, dynamic> toMap() => {
        'debtId': debtId,
        'amountPaid': amountPaid,
        'remainingAfter': remainingAfter,
        'paidAt': paidAt.toIso8601String(),
        'isFinal': isFinal,
      };

  factory DebtPaymentEntry.fromMap(Map<String, dynamic> m) => DebtPaymentEntry(
        debtId: m['debtId'] as String,
        amountPaid: (m['amountPaid'] as num).toDouble(),
        remainingAfter: (m['remainingAfter'] as num).toDouble(),
        paidAt: DateTime.parse(m['paidAt'] as String),
        isFinal: m['isFinal'] as bool? ?? false,
      );
}
