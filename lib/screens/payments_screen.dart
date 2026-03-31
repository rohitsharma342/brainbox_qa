import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/project.dart';
import '../providers/payment_provider.dart';
import '../widgets/milestone_item.dart';
import '../widgets/payment_summary_card.dart';

class PaymentsScreen extends StatelessWidget {
  final Project project;

  const PaymentsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.textPrimary,
            size: 20,
          ),
        ),
        title: Text(
          'Payments',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          final milestonePayments = paymentProvider.getMilestonePayments(project);
          final totalAmount = paymentProvider.getTotalAmount(project);
          final paidAmount = paymentProvider.getPaidAmount(project);
          final pendingAmount = paymentProvider.getPendingAmount(project);
          final paidCount = paymentProvider.getPaidCount(project);
          final pendingCount = paymentProvider.getPendingCount(project);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PaymentSummaryCard(
                  totalAmount: totalAmount,
                  paidAmount: paidAmount,
                  pendingAmount: pendingAmount,
                  paidCount: paidCount,
                  pendingCount: pendingCount,
                  totalMilestones: project.milestones.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'All',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final milestonePayment = milestonePayments[index];
                      final isLast = index == milestonePayments.length - 1;
                      return MilestonePaymentItem(
                        milestonePayment: milestonePayment,
                        isLast: isLast,
                      );
                    },
                    childCount: milestonePayments.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}