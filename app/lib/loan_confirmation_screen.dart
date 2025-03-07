import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/loan.dart';
import 'dashboard_screen.dart';

class LoanConfirmationScreen extends StatelessWidget {
  final double amount;
  final int durationMonths;
  final double interestRate;
  final List<Collateral> collaterals;

  const LoanConfirmationScreen({
    Key? key,
    required this.amount,
    required this.durationMonths,
    required this.interestRate,
    required this.collaterals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthlyPayment =
        _calculateMonthlyPayment(amount, interestRate, durationMonths);
    final totalCollateralValue =
        collaterals.fold<double>(0, (sum, item) => sum + item.currentValue);
    final healthFactor = totalCollateralValue / amount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Loan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loan Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Review your loan details before confirming',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLoanOverview(context),
                      const SizedBox(height: 24),
                      _buildDetailsList(context, monthlyPayment,
                          totalCollateralValue, healthFactor),
                      const SizedBox(height: 24),
                      _buildCollateralSection(context),
                      const SizedBox(height: 24),
                      _buildTermsAndConditions(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanOverview(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.7),
            const Color.fromARGB(255, 42, 0, 107),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loan Amount',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const Divider(color: Colors.white24, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOverviewItem(context, '${interestRate.toStringAsFixed(2)}%',
                  'Interest Rate'),
              _buildOverviewItem(context, '$durationMonths months', 'Duration'),
              _buildOverviewItem(context, '${collaterals.length}',
                  collaterals.length == 1 ? 'Collateral' : 'Collaterals'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList(BuildContext context, double monthlyPayment,
      double totalCollateralValue, double healthFactor) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
              'Monthly Payment', '\$${monthlyPayment.toStringAsFixed(2)}'),
          _buildDetailRow('Total Repayment',
              '\$${(monthlyPayment * durationMonths).toStringAsFixed(2)}'),
          _buildDetailRow('Total Interest',
              '\$${(monthlyPayment * durationMonths - amount).toStringAsFixed(2)}'),
          _buildDetailRow('Collateral Value',
              '\$${totalCollateralValue.toStringAsFixed(2)}'),
          _buildDetailRow(
            'Health Factor',
            healthFactor.toStringAsFixed(2),
            valueColor: _getHealthFactorColor(healthFactor),
          ),
          _buildDetailRow('Liquidation Threshold', '80%'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            // style: .textTheme.bodyMedium?.copyWith(
            //   color: Colors.grey[400],
            // ),
          ),
          Text(
            value,
            // style: .textTheme.bodyMedium?.copyWith(
            //   fontWeight: FontWeight.bold,
            //   color: valueColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCollateralSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collateral',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...collaterals
            .map((collateral) => _buildCollateralItem(context, collateral)),
      ],
    );
  }

  Widget _buildCollateralItem(BuildContext context, Collateral collateral) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: collateral.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              collateral.name[0],
              style: TextStyle(
                color: collateral.color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(collateral.name),
        subtitle: Text(
          '${collateral.amount.toStringAsFixed(4)} ${collateral.name}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        trailing: Text(
          '\$${collateral.currentValue.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Terms & Conditions',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTermItem(
              'Your collateral will be locked until the loan is fully repaid.'),
          _buildTermItem(
              'If the health factor falls below 1.0, your collateral may be liquidated.'),
          _buildTermItem(
              'You can repay the loan early with no prepayment penalties.'),
          _buildTermItem(
              'You can top up your collateral at any time to increase your health factor.'),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: () {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Loan Approved!'),
              content: const Text(
                'Your loan has been approved and the funds will be transferred to your wallet shortly.',
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate back to dashboard
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          );
        },
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
        child: const Text('Confirm and Get Loan'),
      ),
    );
  }

  double _calculateMonthlyPayment(
      double principal, double interestRate, int durationMonths) {
    if (principal <= 0 || durationMonths <= 0) return 0;

    final monthlyRate = interestRate / 100 / 12;
    return principal *
        monthlyRate *
        math.pow(1 + monthlyRate, durationMonths) /
        (math.pow(1 + monthlyRate, durationMonths) - 1);
  }

  Color _getHealthFactorColor(double factor) {
    if (factor >= 2.0) return Colors.green;
    if (factor >= 1.5) return Colors.lightGreen;
    if (factor >= 1.2) return Colors.amber;
    if (factor >= 1.0) return Colors.orange;
    return Colors.red;
  }
}
