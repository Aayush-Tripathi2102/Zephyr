import 'package:flutter/material.dart';
import '../models/loan.dart';

class CollateralCard extends StatelessWidget {
  final Collateral collateral;
  final VoidCallback? onTopUp;

  const CollateralCard({
    Key? key,
    required this.collateral,
    this.onTopUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHealthy = collateral.currentValue >= collateral.initialValue * collateral.liquidationThreshold;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isHealthy ? Colors.transparent : Colors.red.withOpacity(0.6),
          width: isHealthy ? 0 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: collateral.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      collateral.name[0], // First letter as a fallback icon
                      style: TextStyle(
                        color: collateral.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collateral.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${collateral.amount.toStringAsFixed(4)} ${collateral.name}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${collateral.currentValue.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          collateral.currentValue >= collateral.initialValue
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 14,
                          color: collateral.currentValue >= collateral.initialValue
                              ? Colors.green
                              : Colors.red,
                        ),
                        Text(
                          '${((collateral.currentValue / collateral.initialValue - 1) * 100).abs().toStringAsFixed(2)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: collateral.currentValue >= collateral.initialValue
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: collateral.currentValue / (collateral.initialValue * collateral.liquidationThreshold * 1.5),
              backgroundColor: theme.colorScheme.surface,
              color: _getHealthColor(collateral.currentValue / (collateral.initialValue * collateral.liquidationThreshold)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health: ${((collateral.currentValue / (collateral.initialValue * collateral.liquidationThreshold)) * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getHealthColor(collateral.currentValue / (collateral.initialValue * collateral.liquidationThreshold)),
                  ),
                ),
                if (onTopUp != null)
                  TextButton.icon(
                    onPressed: onTopUp,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Top up'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getHealthColor(double healthRatio) {
    if (healthRatio >= 1.5) return Colors.green;
    if (healthRatio >= 1.2) return Colors.greenAccent;
    if (healthRatio >= 1.0) return Colors.yellow;
    if (healthRatio >= 0.8) return Colors.orange;
    return Colors.red;
  }
}
