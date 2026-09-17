import 'package:flutter/material.dart';

class AnalysisStep extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;

  const AnalysisStep({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor;

    if (isCompleted) {
      circleColor = Colors.green;
    } else if (isCurrent) {
      circleColor = const Color(0xFF5B4BEA);
    } else {
      circleColor = Colors.grey.shade300;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrent
              ? const Color(0xFF5B4BEA)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : isCurrent
                      ? Icons.sync
                      : Icons.circle_outlined,
              color: isCompleted || isCurrent
                  ? Colors.white
                  : Colors.grey,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrent
                        ? const Color(0xFF5B4BEA)
                        : const Color(0xFF071A35),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}