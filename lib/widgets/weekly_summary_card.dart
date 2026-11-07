import 'package:flutter/material.dart';

class WeeklySummaryCard extends StatelessWidget {
  final int resolvedCount;

  const WeeklySummaryCard({
    super.key,
    this.resolvedCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8ECE9),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Bar chart icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF2E7D5B),
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          // Label
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'THIS WEEK ',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: Color(0xFF7D8E87),
                    ),
                  ),
                  TextSpan(
                    text: '$resolvedCount requests resolved',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2E26),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mini bar chart representation
          const _MiniBarChart(),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    // 7 days bar heights
    final heights = [10.0, 14.0, 18.0, 12.0, 26.0, 32.0, 16.0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(heights.length, (index) {
        final isHighest = index == 5; // Highlighted bar
        return Container(
          width: 5.5,
          height: heights[index],
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: isHighest ? const Color(0xFF2E634E) : const Color(0xFFD6E2DC),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
