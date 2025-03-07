import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/loan.dart';

class CreditScoreGauge extends StatelessWidget {
  final CreditScore creditScore;

  const CreditScoreGauge({
    Key? key,
    required this.creditScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              // Background arc
              Center(
                child: CustomPaint(
                  size: const Size(220, 220),
                  painter: _ScoreArcPainter(
                    score: creditScore.score,
                    maxScore: 850,
                    minScore: 300,
                  ),
                ),
              ),
              // Score text
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      creditScore.score.toString(),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      creditScore.category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: creditScore.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildScoreRanges(),
      ],
    );
  }

  Widget _buildScoreRanges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreRange('Poor', '300-549', const Color(0xFFF44336), creditScore.score >= 300 && creditScore.score <= 549),
        _buildScoreRange('Fair', '550-649', const Color(0xFFFF9800), creditScore.score >= 550 && creditScore.score <= 649),
        _buildScoreRange('Good', '650-749', const Color(0xFFFFC107), creditScore.score >= 650 && creditScore.score <= 749),
        _buildScoreRange('Very Good', '750-799', const Color(0xFF8BC34A), creditScore.score >= 750 && creditScore.score <= 799),
        _buildScoreRange('Excellent', '800-850', const Color(0xFF4CAF50), creditScore.score >= 800 && creditScore.score <= 850),
      ],
    );
  }

  Widget _buildScoreRange(String label, String range, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? color : Colors.grey,
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _ScoreArcPainter extends CustomPainter {
  final int score;
  final int maxScore;
  final int minScore;

  _ScoreArcPainter({
    required this.score,
    required this.maxScore,
    required this.minScore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;

    // Draw background arc
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey.withOpacity(0.2);

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    // Calculate score percentage and corresponding angle
    final scorePercentage = (score - minScore) / (maxScore - minScore);
    final scoreAngle = sweepAngle * scorePercentage;

    // Create gradient for score arc
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: const [
        Color(0xFFF44336), // Poor
        Color(0xFFFF9800), // Fair
        Color(0xFFFFC107), // Good
        Color(0xFF8BC34A), // Very Good
        Color(0xFF4CAF50), // Excellent
      ],
    );

    final scorePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Draw score arc
    canvas.drawArc(rect, startAngle, scoreAngle, false, scorePaint);

    // Draw pointer
    final pointerAngle = startAngle + scoreAngle;
    final pointerX = (size.width / 2) + (size.width / 2 - 30) * math.cos(pointerAngle);
    final pointerY = (size.height / 2) + (size.height / 2 - 30) * math.sin(pointerAngle);

    final pointerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(pointerX, pointerY), 8, pointerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
