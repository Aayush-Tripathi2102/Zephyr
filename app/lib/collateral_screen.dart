import 'package:flutter/material.dart';
import '../models/loan.dart';
import 'components/collateral_card.dart';

class CollateralScreen extends StatelessWidget {
  final Loan? loan;

  const CollateralScreen({
    Key? key,
    this.loan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data if no loan is provided
    final activeLoans = [
      if (loan != null) loan!,
      if (loan == null)
        Loan(
          id: 'L1024',
          amount: 5000,
          interestRate: 3.5,
          durationMonths: 12,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          collaterals: [
            Collateral(
              type: CollateralType.ETH,
              amount: 2.5,
              initialValue: 4000,
              currentValue: 4200,
              liquidationThreshold: 0.8,
            ),
            Collateral(
              type: CollateralType.BTC,
              amount: 0.05,
              initialValue: 1500,
              currentValue: 1420,
              liquidationThreshold: 0.8,
            ),
          ],
          status: LoanStatus.active,
          remainingAmount: 4250,
          nextPaymentAmount: 430.50,
          nextPaymentDate: DateTime.now().add(const Duration(days: 5)),
        ),
    ];

    final selectedLoan = activeLoans.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collateral Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCollateralOverview(context, selectedLoan),
                const SizedBox(height: 24),
                Text(
                  'Your Collateral',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...selectedLoan.collaterals.map((collateral) => CollateralCard(
                  collateral: collateral,
                  onTopUp: () {
                    _showTopUpDialog(context, collateral);
                  },
                )),
                const SizedBox(height: 24),
                _buildLiquidationInfoCard(context, selectedLoan),
                const SizedBox(height: 24),
                _buildCollateralHistorySection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollateralOverview(BuildContext context, Loan loan) {
    final theme = Theme.of(context);
    final totalCollateralValue = loan.collaterals.fold<double>(
        0, (sum, item) => sum + item.currentValue);
    final healthFactor = loan.healthFactor;
    final healthColor = _getHealthFactorColor(healthFactor);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loan #${loan.id}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(loan.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(loan.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(loan.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${totalCollateralValue.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Collateral Value',
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
                      Row(
                        children: [
                          Text(
                            healthFactor.toStringAsFixed(2),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: healthColor,
                            ),
                          ),
                          Icon(
                            healthFactor >= 1.2 ? Icons.check_circle : Icons.warning,
                            color: healthColor,
                            size: 20,
                          ),
                        ],
                      ),
                      Text(
                        'Health Factor',
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
              value: healthFactor / 2.0, // Consider 2.0 as the max for the progress bar
              backgroundColor: theme.colorScheme.surface,
              color: healthColor,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Liquidation at < 1.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ),
              Text(
                'Safe > 1.5',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
          if (healthFactor < 1.2) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Add More Collateral'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiquidationInfoCard(BuildContext context, Loan loan) {
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
                'Liquidation Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem('Your collateral will be liquidated if the health factor falls below 1.0.'),
          _buildInfoItem('We liquidate in batches, giving you time to top up your collateral.'),
          _buildInfoItem('You will receive notifications when your health factor is at risk.'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.article_outlined, size: 16),
            label: const Text('Read Liquidation Policy'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollateralHistorySection(BuildContext context) {
    final theme = Theme.of(context);

    // Sample history data
    final historyItems = [
      CollateralHistoryItem(
        type: 'Added',
        asset: 'ETH',
        amount: 1.5,
        value: 2400,
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
      CollateralHistoryItem(
        type: 'Added',
        asset: 'BTC',
        amount: 0.05,
        value: 1500,
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
      CollateralHistoryItem(
        type: 'Top-up',
        asset: 'ETH',
        amount: 1.0,
        value: 1600,
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collateral History',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...historyItems.map((item) => _buildHistoryItem(context, item)),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, CollateralHistoryItem item) {
    final theme = Theme.of(context);
    final isAdded = item.type == 'Added' || item.type == 'Top-up';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isAdded ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isAdded ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: isAdded ? Colors.green : Colors.red,
          ),
        ),
        title: Row(
          children: [
            Text(
              '${item.type} ${item.amount} ${item.asset}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(\$${item.value.toStringAsFixed(2)})',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${_formatDate(item.date)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
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

  void _showTopUpDialog(BuildContext context, Collateral collateral) {
    double amount = 0;
    final maxAmount = 10.0; // Example max amount available

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final value = amount * (collateral.currentValue / collateral.amount);

          return AlertDialog(
            title: Text('Top Up ${collateral.name} Collateral'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current: ${collateral.amount.toStringAsFixed(4)} ${collateral.name}'),
                const SizedBox(height: 16),
                Text(
                  'Add: ${amount.toStringAsFixed(4)} ${collateral.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Value: \$${value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: amount,
                  min: 0,
                  max: maxAmount,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('0'),
                    Text('${maxAmount.toStringAsFixed(4)} ${collateral.name}'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: amount > 0
                    ? () {
                  // Add collateral logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${amount.toStringAsFixed(4)} ${collateral.name} to your collateral'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
                    : null,
                child: const Text('Top Up'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

class CollateralHistoryItem {
  final String type;
  final String asset;
  final double amount;
  final double value;
  final DateTime date;

  CollateralHistoryItem({
    required this.type,
    required this.asset,
    required this.amount,
    required this.value,
    required this.date,
  });
}
