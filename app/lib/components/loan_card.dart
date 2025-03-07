import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/loan.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback? onRepay;
  final VoidCallback? onManageCollateral;

  const LoanCard({
    Key? key,
    required this.loan,
    this.onRepay,
    this.onManageCollateral,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getStatusColor(loan.status).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    _getStatusText(loan.status),
                    style: TextStyle(
                      color: _getStatusColor(loan.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getStatusColor(loan.status).withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Loan #${loan.id}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${loan.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Loan Amount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.grey[800],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${loan.remainingAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Remaining Balance',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 1 - (loan.remainingAmount / loan.amount),
                backgroundColor: theme.colorScheme.surface,
                color: theme.colorScheme.primary,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                      context,
                      'Interest Rate',
                      '${loan.interestRate.toStringAsFixed(2)}%',
                      Icons.percent
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                      context,
                      'Duration',
                      '${loan.durationMonths} months',
                      Icons.calendar_today
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Health Factor',
                    loan.healthFactor.toStringAsFixed(2),
                    Icons.health_and_safety,
                    valueColor: _getHealthFactorColor(loan.healthFactor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Payment',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '\$${loan.nextPaymentAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(loan.nextPaymentDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (onManageCollateral != null)
                      OutlinedButton.icon(
                        onPressed: onManageCollateral,
                        icon: const Icon(Icons.shield_outlined, size: 16),
                        label: const Text('Collateral'),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (onRepay != null)
                      FilledButton.icon(
                        onPressed: onRepay,
                        icon: const Icon(Icons.payments_outlined, size: 16),
                        label: const Text('Repay'),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon, {Color? valueColor}) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  String _getStatusText(LoanStatus status) {
    switch (status) {
      case LoanStatus.active: return 'Active';
      case LoanStatus.pending: return 'Pending';
      case LoanStatus.completed: return 'Completed';
      case LoanStatus.atrisk: return 'At Risk';
    }
  }

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.active: return Colors.green;
      case LoanStatus.pending: return Colors.blue;
      case LoanStatus.completed: return Colors.purple;
      case LoanStatus.atrisk: return Colors.red;
    }
  }

  Color _getHealthFactorColor(double factor) {
    if (factor >= 2.0) return Colors.green;
    if (factor >= 1.5) return Colors.lightGreen;
    if (factor >= 1.2) return Colors.amber;
    if (factor >= 1.0) return Colors.orange;
    return Colors.red;
  }
}
