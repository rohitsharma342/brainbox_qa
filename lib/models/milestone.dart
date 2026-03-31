import 'payment.dart';

class MilestonePayment {
  final String milestoneId;
  final String milestoneTitle;
  final String milestoneDescription;
  final int milestoneOrder;
  final bool milestoneCompleted;
  final DateTime? milestoneCompletedDate;
  final Payment? payment;

  MilestonePayment({
    required this.milestoneId,
    required this.milestoneTitle,
    required this.milestoneDescription,
    required this.milestoneOrder,
    required this.milestoneCompleted,
    this.milestoneCompletedDate,
    this.payment,
  });

  bool get hasPendingPayment => payment != null && payment!.isPending;
  bool get isPaid => payment != null && payment!.isPaid;
  bool get isOverdue => payment != null && payment!.isOverdue;
}