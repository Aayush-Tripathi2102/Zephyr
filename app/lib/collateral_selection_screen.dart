import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/loan.dart';
import 'loan_confirmation_screen.dart';

class CollateralSelectionScreen extends StatefulWidget {
  final double amount;
  final int durationMonths;
  final double interestRate;

  final Function(double amount, double collateral) createLoan;


  const CollateralSelectionScreen(
      {super.key,
      required this.amount,
      required this.durationMonths,
      required this.interestRate,
      required this.createLoan});

  @override
  State<CollateralSelectionScreen> createState() =>
      _CollateralSelectionScreenState();
}

class _CollateralSelectionScreenState extends State<CollateralSelectionScreen> {
  final List<CollateralOption> _availableCollaterals = [
    CollateralOption(
      type: CollateralType.ETH,
      name: 'Ethereum',
      symbol: 'ETH',
      price: 1680.0,
      balance: 2.8,
      liquidationThreshold: 0.8,
    ),
    CollateralOption(
      type: CollateralType.BTC,
      name: 'Bitcoin',
      symbol: 'BTC',
      price: 30000.0,
      balance: 0.15,
      liquidationThreshold: 0.75,
    ),
    CollateralOption(
      type: CollateralType.SOL,
      name: 'Solana',
      symbol: 'SOL',
      price: 40.0,
      balance: 120.0,
      liquidationThreshold: 0.7,
    ),
    CollateralOption(
      type: CollateralType.AVAX,
      name: 'Avalanche',
      symbol: 'AVAX',
      price: 29.0,
      balance: 75.0,
      liquidationThreshold: 0.7,
    ),
    CollateralOption(
      type: CollateralType.MATIC,
      name: 'Polygon',
      symbol: 'MATIC',
      price: 0.8,
      balance: 2000.0,
      liquidationThreshold: 0.65,
    ),
  ];

  // Selected collaterals with amounts
  final List<SelectedCollateral> _selectedCollaterals = [];

  // Minimum required collateral value (based on LTV)
  double _getMinCollateralValue() {
    return widget.amount * 1.25; // Assuming 80% LTV (1/0.8 = 1.25)
  }

  // Current total collateral value
  double _getCurrentCollateralValue() {
    double total = 0;
    for (var collateral in _selectedCollaterals) {
      total += collateral.amount * collateral.option.price;
    }
    return total;
  }

  // Health factor based on collateral value
  double _getHealthFactor() {
    final collateralValue = _getCurrentCollateralValue();
    if (widget.amount == 0) return 0;
    return collateralValue / widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minCollateralValue = _getMinCollateralValue();
    final currentCollateralValue = _getCurrentCollateralValue();
    final healthFactor = _getHealthFactor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Collateral'),
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
                        'Add Collateral',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You need to provide at least \$${minCollateralValue.toStringAsFixed(2)} worth of collateral for this loan',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildCollateralProgress(context, currentCollateralValue,
                          minCollateralValue, healthFactor),
                      const SizedBox(height: 24),
                      if (_selectedCollaterals.isNotEmpty) ...[
                        Text(
                          'Selected Collateral',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._selectedCollaterals.map((selected) =>
                            _buildSelectedCollateralItem(context, selected)),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        'Available Assets',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._availableCollaterals.map((collateral) =>
                          _buildCollateralItem(context, collateral)),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(
                context, currentCollateralValue, minCollateralValue),
          ],
        ),
      ),
    );
  }

  Widget _buildCollateralProgress(BuildContext context, double currentValue,
      double minValue, double healthFactor) {
    final theme = Theme.of(context);
    final progressPercentage = math.min(1.0, currentValue / minValue);
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
                'Collateral Progress',
                style: theme.textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: healthColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Health: ${healthFactor.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: healthColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: theme.colorScheme.surface,
              color: healthColor,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${currentValue.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Current Value',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${minValue.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Minimum Required',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollateralItem(
      BuildContext context, CollateralOption collateral) {
    final theme = Theme.of(context);
    final isSelected = _selectedCollaterals
        .any((selected) => selected.option.type == collateral.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCryptoColor(collateral.type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              collateral.symbol[0],
              style: TextStyle(
                color: _getCryptoColor(collateral.type),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(collateral.name),
        subtitle: Text(
          '${collateral.balance} ${collateral.symbol} · \$${(collateral.balance * collateral.price).toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : TextButton(
                onPressed: () => _showAddCollateralDialog(collateral),
                child: const Text('Add'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
        onTap: () => _showAddCollateralDialog(collateral),
      ),
    );
  }

  Widget _buildSelectedCollateralItem(
      BuildContext context, SelectedCollateral selected) {
    final theme = Theme.of(context);
    final collateral = selected.option;
    final value = selected.amount * collateral.price;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCryptoColor(collateral.type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              collateral.symbol[0],
              style: TextStyle(
                color: _getCryptoColor(collateral.type),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(collateral.name),
        subtitle: Text(
          '${selected.amount} ${collateral.symbol} · \$${value.toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _selectedCollaterals
                  .removeWhere((item) => item.option.type == collateral.type);
            });
          },
        ),
        onTap: () => _showAddCollateralDialog(collateral),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, double currentValue, double minValue) {
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
        onPressed: currentValue >= minValue
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoanConfirmationScreen(
                      amount: widget.amount,
                      durationMonths: widget.durationMonths,
                      interestRate: widget.interestRate,
                      collaterals: _selectedCollaterals
                          .map((selected) => Collateral(
                                type: selected.option.type,
                                amount: selected.amount,
                                initialValue:
                                    selected.amount * selected.option.price,
                                currentValue:
                                    selected.amount * selected.option.price,
                                liquidationThreshold:
                                    selected.option.liquidationThreshold,
                              ))
                          .toList(),
                    ),
                  ),
                );
              }
            : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
        child: Text(
          currentValue >= minValue
              ? 'Continue to Review'
              : 'Add More Collateral (${((minValue - currentValue) / minValue * 100).toStringAsFixed(0)}% more needed)',
        ),
      ),
    );
  }

  void _showAddCollateralDialog(CollateralOption collateral) {
    final existingIndex = _selectedCollaterals
        .indexWhere((item) => item.option.type == collateral.type);
    double initialAmount =
        existingIndex != -1 ? _selectedCollaterals[existingIndex].amount : 0;
    double amount = initialAmount;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final value = amount * collateral.price;
          final maxAmount = collateral.balance;

          return AlertDialog(
            title: Text('Add ${collateral.name} as Collateral'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Available: ${collateral.balance} ${collateral.symbol}'),
                const SizedBox(height: 16),
                Text(
                  'Amount: ${amount.toStringAsFixed(4)} ${collateral.symbol}',
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
                    Text(
                        '${maxAmount.toStringAsFixed(4)} ${collateral.symbol}'),
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
                        this.setState(() {
                          if (existingIndex != -1) {
                            if (amount == 0) {
                              _selectedCollaterals.removeAt(existingIndex);
                            } else {
                              _selectedCollaterals[existingIndex] =
                                  SelectedCollateral(
                                option: collateral,
                                amount: amount,
                              );
                            }
                          } else {
                            _selectedCollaterals.add(SelectedCollateral(
                              option: collateral,
                              amount: amount,
                            ));
                          }
                        });
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(existingIndex != -1 ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getCryptoColor(CollateralType type) {
    switch (type) {
      case CollateralType.ETH:
        return const Color(0xFF627EEA);
      case CollateralType.BTC:
        return const Color(0xFFF7931A);
      case CollateralType.SOL:
        return const Color(0xFF00FFA3);
      case CollateralType.AVAX:
        return const Color(0xFFE84142);
      case CollateralType.MATIC:
        return const Color(0xFF8247E5);
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

class CollateralOption {
  final CollateralType type;
  final String name;
  final String symbol;
  final double price;
  final double balance;
  final double liquidationThreshold;

  CollateralOption({
    required this.type,
    required this.name,
    required this.symbol,
    required this.price,
    required this.balance,
    required this.liquidationThreshold,
  });
}

class SelectedCollateral {
  final CollateralOption option;
  final double amount;

  SelectedCollateral({
    required this.option,
    required this.amount,
  });
}
