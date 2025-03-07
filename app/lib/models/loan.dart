import 'dart:ui';

enum LoanStatus {
  active,
  pending,
  completed,
  atrisk,
}

enum CollateralType {
  ETH,
  BTC,
  SOL,
  AVAX,
  MATIC,
}

class Loan {
  final String id;
  final double amount;
  final double interestRate;
  final int durationMonths;
  final DateTime startDate;
  final List<Collateral> collaterals;
  final LoanStatus status;
  final double remainingAmount;
  final double nextPaymentAmount;
  final DateTime nextPaymentDate;

  Loan({
    required this.id,
    required this.amount,
    required this.interestRate,
    required this.durationMonths,
    required this.startDate,
    required this.collaterals,
    required this.status,
    required this.remainingAmount,
    required this.nextPaymentAmount,
    required this.nextPaymentDate,
  });

  // Calculate health factor based on collateral value vs loan amount
  double get healthFactor {
    double totalCollateralValue = 0;
    for (var collateral in collaterals) {
      totalCollateralValue += collateral.currentValue;
    }

    // Health factor = total collateral value / remaining loan amount
    // Higher is better, below 1.0 is at risk of liquidation
    return totalCollateralValue / remainingAmount;
  }

  // Check if loan is at risk of liquidation
  bool get isAtRiskOfLiquidation {
    return healthFactor < 1.2; // Typical threshold
  }
}

class Collateral {
  final CollateralType type;
  final double amount;
  final double initialValue;
  final double currentValue;
  final double liquidationThreshold;

  Collateral({
    required this.type,
    required this.amount,
    required this.initialValue,
    required this.currentValue,
    required this.liquidationThreshold,
  });

  // Get icon for this collateral type
  String get icon {
    switch (type) {
      case CollateralType.ETH:
        return 'assets/icons/eth.png';
      case CollateralType.BTC:
        return 'assets/icons/btc.png';
      case CollateralType.SOL:
        return 'assets/icons/sol.png';
      case CollateralType.AVAX:
        return 'assets/icons/avax.png';
      case CollateralType.MATIC:
        return 'assets/icons/matic.png';
    }
  }

  // Get color for this collateral type
  Color get color {
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

  // Get name for this collateral type
  String get name {
    return type.toString().split('.').last;
  }
}

class CreditScore {
  final int score;
  final String category;
  final List<ScoreHistoryPoint> history;
  final Map<String, double> factors;

  CreditScore({
    required this.score,
    required this.category,
    required this.history,
    required this.factors,
  });

  // Get color based on score category
  Color get color {
    if (score >= 750) return const Color(0xFF4CAF50);
    if (score >= 650) return const Color(0xFF8BC34A);
    if (score >= 550) return const Color(0xFFFFC107);
    if (score >= 450) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}

class ScoreHistoryPoint {
  final DateTime date;
  final int score;

  ScoreHistoryPoint({
    required this.date,
    required this.score,
  });
}
