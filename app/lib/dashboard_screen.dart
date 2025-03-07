import 'package:flutter/material.dart';
import 'package:zephyr/repay_screen.dart';
import '../models/loan.dart';
import 'collateral_screen.dart';
import 'components/collateral_card.dart';
import 'components/loan_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final activeLoans = [
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
      Loan(
        id: 'L1025',
        amount: 2000,
        interestRate: 4.0,
        durationMonths: 6,
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        collaterals: [
          Collateral(
            type: CollateralType.SOL,
            amount: 60,
            initialValue: 2400,
            currentValue: 2150,
            liquidationThreshold: 0.8,
          ),
        ],
        status: LoanStatus.atrisk,
        remainingAmount: 1900,
        nextPaymentAmount: 345.20,
        nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zephyr - Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildActivitySummary(context),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Active Loans', 'View All'),
                const SizedBox(height: 8),
                ...activeLoans.map((loan) => LoanCard(
                  loan: loan,
                  onRepay: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepayScreen(loan: loan),
                      ),
                    );
                  },
                  onManageCollateral: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollateralScreen(loan: loan),
                      ),
                    );
                  },
                )),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Collateral Health', 'Manage'),
                const SizedBox(height: 8),
                ...activeLoans[0].collaterals.map((collateral) => CollateralCard(
                  collateral: collateral,
                  onTopUp: () {
                    // Navigate to top-up screen
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$6,150.00',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        FilledButton(
          onPressed: () {},
          child: const Text('Borrow More'),
        ),
      ],
    );
  }

  Widget _buildActivitySummary(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActivityItem(context, 'Active Loans', '2'),
              _buildDivider(),
              _buildActivityItem(context, 'Total Borrowed', '\$7,000'),
              _buildDivider(),
              _buildActivityItem(context, 'Collateral Value', '\$7,770'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Factor',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              Text(
                '1.27',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String actionText) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(actionText),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ],
    );
  }
}
