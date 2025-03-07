import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'collateral_selection_screen.dart';
import 'dart:math' as math;

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({
    super.key,
    required this.getInterestRate,
    required this.createLoan

  });

  final Future<double> Function() getInterestRate;

  final Function(double amount, double collateralValue) createLoan;

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  int _durationMonths = 6;
  double _interestRate = 3.5;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrow'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How much would you like to borrow?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the amount and choose your loan terms',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildAmountInput(context),
                  const SizedBox(height: 24),
                  _buildDurationSlider(context),
                  const SizedBox(height: 24),
                  _buildLoanSummary(context),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> loanInfo = {
                          'amount': _amountController.text,
                          'interestRate': widget.getInterestRate(),
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CollateralSelectionScreen(
                              amount: double.parse(_amountController.text),
                              durationMonths: _durationMonths,
                              interestRate: _interestRate,
                              createLoan: widget.createLoan
                            ),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const ui.Size(double.infinity, 56),
                    ),
                    child: const Text('Continue to Collateral'),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturesList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Amount',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              child: Text(
                '\$',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            hintText: '0.00',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _amountController.clear(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = double.tryParse(value);
            if (amount == null) {
              return 'Please enter a valid number';
            }
            if (amount < 100) {
              return 'Minimum loan amount is \$100';
            }
            if (amount > 50000) {
              return 'Maximum loan amount is \$50,000';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Min: \$100 - Max: \$50,000',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSlider(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Loan Duration',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              '$_durationMonths months',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _durationMonths.toDouble(),
          min: 1,
          max: 36,
          divisions: 35,
          onChanged: (value) {
            setState(() {
              _durationMonths = value.round();
              // Adjust interest rate based on duration
              if (_durationMonths <= 6) {
                _interestRate = 3.5;
              } else if (_durationMonths <= 12) {
                _interestRate = 4.0;
              } else if (_durationMonths <= 24) {
                _interestRate = 4.5;
              } else {
                _interestRate = 5.0;
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 month',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[400],
              ),
            ),
            Text(
              '36 months',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoanSummary(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final monthlyPayment =
        _calculateMonthlyPayment(amount, _interestRate, _durationMonths);

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
            'Loan Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Loan Amount', '\$${amount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
              'Interest Rate', '${_interestRate.toStringAsFixed(2)}%'),
          const SizedBox(height: 8),
          _buildSummaryRow('Loan Duration', '$_durationMonths months'),
          const SizedBox(height: 8),
          _buildSummaryRow('Estimated Monthly Payment',
              '\$${monthlyPayment.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Total Repayment',
              '\$${(monthlyPayment * _durationMonths).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.shield_outlined,
          title: 'Multiple Collateral Types',
          description: 'Use ETH, BTC, SOL, and more as collateral',
        ),
        _buildFeatureItem(
          icon: Icons.add_circle_outline,
          title: 'Top-Up Collateral',
          description: 'Add more collateral at any time to avoid liquidation',
        ),
        _buildFeatureItem(
          icon: Icons.bar_chart,
          title: 'Credit Score Impact',
          description:
              'Improve your on-chain credit score with timely repayments',
        ),
        _buildFeatureItem(
          icon: Icons.payments_outlined,
          title: 'Flexible Repayment',
          description: 'Pay in monthly installments or make early repayments',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
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
}
