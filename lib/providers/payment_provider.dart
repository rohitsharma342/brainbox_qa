import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../models/milestone.dart';
import '../models/project.dart';

class PaymentProvider with ChangeNotifier {
  final Map<String, List<Payment>> _projectPayments = {};

  List<Payment> getPaymentsForProject(String projectId) {
    return _projectPayments[projectId] ?? [];
  }

  List<MilestonePayment> getMilestonePayments(Project project) {
    final payments = getPaymentsForProject(project.id);
    
    return project.milestones.map((milestone) {
      final payment = payments.firstWhere(
        (p) => p.milestoneId == milestone.id,
        orElse: () => Payment(
          id: 'pending_${milestone.id}',
          milestoneId: milestone.id,
          projectId: project.id,
          amount: _getDefaultAmount(milestone.order),
          status: milestone.isCompleted ? PaymentStatus.pending : PaymentStatus.pending,
          dueDate: DateTime.now().add(const Duration(days: 30)),
        ),
      );
      
      return MilestonePayment(
        milestoneId: milestone.id,
        milestoneTitle: milestone.title,
        milestoneDescription: milestone.description,
        milestoneOrder: milestone.order,
        milestoneCompleted: milestone.isCompleted,
        milestoneCompletedDate: milestone.completedDate,
        payment: payment,
      );
    }).toList();
  }

  double _getDefaultAmount(int order) {
    switch (order) {
      case 1:
        return 5000.0;
      case 2:
        return 8000.0;
      case 3:
        return 12000.0;
      case 4:
        return 10000.0;
      case 5:
        return 8000.0;
      case 6:
        return 7000.0;
      default:
        return 5000.0;
    }
  }

  double getTotalAmount(Project project) {
    final milestonePayments = getMilestonePayments(project);
    return milestonePayments.fold(0.0, (sum, mp) => sum + (mp.payment?.amount ?? 0));
  }

  double getPaidAmount(Project project) {
    final milestonePayments = getMilestonePayments(project);
    return milestonePayments
        .where((mp) => mp.isPaid)
        .fold(0.0, (sum, mp) => sum + (mp.payment?.amount ?? 0));
  }

  double getPendingAmount(Project project) {
    final milestonePayments = getMilestonePayments(project);
    return milestonePayments
        .where((mp) => mp.hasPendingPayment || mp.isOverdue)
        .fold(0.0, (sum, mp) => sum + (mp.payment?.amount ?? 0));
  }

  int getPaidCount(Project project) {
    final milestonePayments = getMilestonePayments(project);
    return milestonePayments.where((mp) => mp.isPaid).length;
  }

  int getPendingCount(Project project) {
    final milestonePayments = getMilestonePayments(project);
    return milestonePayments.where((mp) => mp.hasPendingPayment || mp.isOverdue).length;
  }

  void initializeMockPayments(List<Project> projects) {
    for (var project in projects) {
      List<Payment> payments = [];
      for (var milestone in project.milestones) {
        PaymentStatus status;
        DateTime? paidDate;
        String? transactionId;
        String? paymentMethod;

        if (milestone.isCompleted) {
          status = PaymentStatus.paid;
          paidDate = milestone.completedDate?.add(const Duration(days: 5));
          transactionId = 'TXN${milestone.id.hashCode.abs()}';
          paymentMethod = 'Bank Transfer';
        } else {
          status = PaymentStatus.pending;
        }

        payments.add(Payment(
          id: 'pay_${milestone.id}',
          milestoneId: milestone.id,
          projectId: project.id,
          amount: _getDefaultAmount(milestone.order),
          status: status,
          paidDate: paidDate,
          dueDate: milestone.completedDate?.add(const Duration(days: 15)) ?? 
                   DateTime.now().add(const Duration(days: 30)),
          transactionId: transactionId,
          paymentMethod: paymentMethod,
        ));
      }
      _projectPayments[project.id] = payments;
    }
    notifyListeners();
  }
}