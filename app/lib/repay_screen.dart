import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan.dart';
import 'dashboard_screen.dart';

class RepayScreen extends StatefulWidget {
  final Loan? loan;

  const RepayScreen({
    Key? key,
    this.loan,
  }) : super(key: key);

  @override
  State<RepayScreen> createState() => _RepayScreenState();
}

class _RepayScreenState extends State<RepayScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Full Amount';
  bool _isCustomAmount = false;

  // Sample payment methods
  final List<String> _paymentOptions = [
    'Full Amount',
    'Next Payment Only',
    'Custom Amount',
  ];

  Loan get loan {
    // Use provided loan or sample data
    return widget.loan ?? Loan(
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
    );
  }

  @override
  void initState() {
    super.initState();
    _updateAmount();
  }

  void _updateAmount() {
    double amount = 0;
    switch (_selectedPaymentMethod) {
      case 'Full Amount':
        amount = loan.remainingAmount;
        break;
      case 'Next Payment Only':
        amount = loan.nextPaymentAmount;
        break;
      case 'Custom Amount':
      // Keep the existing value or set to empty
        _isCustomAmount = true;
        return;
    }
    _isCustomAmount = false;
    _amountController.text = amount.toStringAsFixed(2);
  }

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
        title: const Text('Repay Loan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                          'Loan Repayment',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Make a payment towards your loan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildLoanSummary(context),
                        const SizedBox(height: 24),
                        _buildPaymentMethodSection(context),
                        const SizedBox(height: 24),
                        _buildAmountSection(context),
                        const SizedBox(height: 24),
                        _buildPaymentDetails(context),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanSummary(BuildContext context) {
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
                        '\$${loan.nextPaymentAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Next Payment',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
              ),
              Text(
                '${_formatDate(loan.nextPaymentDate)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interest Rate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
              ),
              Text(
                '${loan.interestRate.toStringAsFixed(2)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collateral Health',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
              ),
              Row(
                children: [
                  Text(
                    loan.healthFactor.toStringAsFixed(2),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getHealthFactorColor(loan.healthFactor),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    loan.healthFactor >= 1.2 ? Icons.check_circle : Icons.warning,
                    color: _getHealthFactorColor(loan.healthFactor),
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_paymentOptions.length, (index) {
          final option = _paymentOptions[index];
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                _updateAmount();
              });
            },
            activeColor: theme.colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }),
      ],
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Amount',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          readOnly: !_isCustomAmount,
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
            if (amount <= 0) {
              return 'Amount must be greater than 0';
            }
            if (amount > loan.remainingAmount) {
              return 'Amount cannot exceed remaining balance';
            }
            return null;
          },
        ),
        if (_isCustomAmount) ...[
          const SizedBox(height: 8),
          Text(
            'Min: \$10 - Max: \$${loan.remainingAmount.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    final theme = Theme.of(context);
    double amount = double.tryParse(_amountController.text) ?? 0;

    // If paying full amount or custom amount greater than remaining, calculate release collateral
    bool willReleaseCollateral = _selectedPaymentMethod == 'Full Amount' ||
        (amount >= loan.remainingAmount && _isCustomAmount);
    bool willImproveHealth = amount > 0 && !willReleaseCollateral;

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
                'Payment Details',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (willReleaseCollateral) ...[
            _buildDetailItem(
              'This payment will fully pay off your loan.',
              Icons.check_circle_outline,
              Colors.green,
            ),
            _buildDetailItem(
              'All collateral will be released back to your wallet.',
              Icons.shield_outlined,
              Colors.green,
            ),
          ] else if (willImproveHealth) ...[
            _buildDetailItem(
              'This payment will reduce your loan balance.',
              Icons.check_circle_outline,
              Colors.blue,
            ),
            _buildDetailItem(
              'Your collateral health factor will improve.',
              Icons.trending_up,
              Colors.blue,
            ),
          ],
          _buildDetailItem(
            'No prepayment penalties for early repayment.',
            Icons.money_off_outlined,
            theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
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
          if (_formKey.currentState!.validate()) {
            // Show success dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Payment Successful!'),
                content: Text(
                  'Your payment of \$${_amountController.text} has been processed successfully.',
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                            (route) => false,
                      );
                    },
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            );
          }
        },
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
        child: Text('Pay \$${_amountController.text}'),
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
