enum PaymentStatus { paid, pending, overdue }

class Payment {
  final String id;
  final String milestoneId;
  final String projectId;
  final double amount;
  final PaymentStatus status;
  final DateTime? paidDate;
  final DateTime dueDate;
  final String? transactionId;
  final String? paymentMethod;

  Payment({
    required this.id,
    required this.milestoneId,
    required this.projectId,
    required this.amount,
    required this.status,
    this.paidDate,
    required this.dueDate,
    this.transactionId,
    this.paymentMethod,
  });

  bool get isPaid => status == PaymentStatus.paid;
  bool get isPending => status == PaymentStatus.pending;
  bool get isOverdue => status == PaymentStatus.overdue;

  String get statusText {
    switch (status) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }
}