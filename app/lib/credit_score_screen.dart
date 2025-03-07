import 'package:flutter/material.dart';
import '../models/loan.dart';
import 'package:fl_chart/fl_chart.dart';

import 'components/credit_score_gauge.dart';

class CreditScoreScreen extends StatelessWidget {
  const CreditScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample credit score data
    final creditScore = CreditScore(
      score: 685,
      category: 'Good',
      history: [
        ScoreHistoryPoint(date: DateTime(2023, 1), score: 620),
        ScoreHistoryPoint(date: DateTime(2023, 2), score: 635),
        ScoreHistoryPoint(date: DateTime(2023, 3), score: 642),
        ScoreHistoryPoint(date: DateTime(2023, 4), score: 655),
        ScoreHistoryPoint(date: DateTime(2023, 5), score: 660),
        ScoreHistoryPoint(date: DateTime(2023, 6), score: 670),
        ScoreHistoryPoint(date: DateTime(2023, 7), score: 685),
      ],
      factors: {
        'Payment History': 0.85,
        'Loan Utilization': 0.70,
        'Loan Age': 0.65,
        'Collateral History': 0.90,
        'Loan Mix': 0.75,
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Score'),
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
                Text(
                  'Your Credit Score',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your on-chain credit score based on your loan activity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                CreditScoreGauge(creditScore: creditScore),
                const SizedBox(height: 24),
                _buildScoreFactors(context, creditScore),
                const SizedBox(height: 24),
                _buildScoreHistory(context, creditScore),
                const SizedBox(height: 24),
                _buildCreditTips(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreFactors(BuildContext context, CreditScore creditScore) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Factors',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...creditScore.factors.entries.map((entry) => _buildFactorItem(context, entry.key, entry.value)),
      ],
    );
  }

  Widget _buildFactorItem(BuildContext context, String name, double value) {
    final theme = Theme.of(context);
    final color = _getFactorColor(value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: theme.colorScheme.surface,
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHistory(BuildContext context, CreditScore creditScore) {
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
            'Score History',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[800]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= creditScore.history.length) return const Text('');
                        final date = creditScore.history[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${date.month}/${date.year.toString().substring(2)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: creditScore.history.length.toDouble() - 1,
                minY: 550, // Adjusted to focus on the score range
                maxY: 750,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      creditScore.history.length,
                          (index) => FlSpot(
                        index.toDouble(),
                        creditScore.history[index].score.toDouble(),
                      ),
                    ),
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditTips(BuildContext context) {
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
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tips to Improve Your Score',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Make your loan payments on time to improve payment history.'),
          _buildTipItem('Keep your loan utilization below 30% of your collateral value.'),
          _buildTipItem('Maintain your loans for longer periods to increase loan age.'),
          _buildTipItem('Use different types of collateral to improve your loan mix.'),
          _buildTipItem('Top up collateral before reaching liquidation threshold.'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.article_outlined, size: 16),
            label: const Text('Learn More About Credit Score'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
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

  Color _getFactorColor(double value) {
    if (value >= 0.8) return Colors.green;
    if (value >= 0.7) return Colors.lightGreen;
    if (value >= 0.6) return Colors.amber;
    if (value >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
