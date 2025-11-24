import 'package:flutter/material.dart';

class OrderProgressLine extends StatelessWidget {
  final String status;
  const OrderProgressLine({super.key, required this.status});

  int _indexFor(String s) {
    switch (s) {
      case 'ordered':
        return 0;
      case 'out_for_delivery':
        return 1;
      case 'delivered':
        return 2;
      default:
        final l = s.toLowerCase();
        if (l.contains('out')) return 1;
        if (l.contains('deliver')) return 2;
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _indexFor(status);
    return Row(
      children: [
        _buildStep('Ordered', active >= 0, active == 0),
        _buildLine(active >= 1),
        _buildStep('Out', active >= 1, active == 1),
        _buildLine(active >= 2),
        _buildStep('Delivered', active >= 2, active == 2),
      ],
    );
  }

  Widget _buildStep(String title, bool done, bool active) {
    final color = done
        ? Colors.green
        : (active ? Colors.orange : Colors.grey.shade300);
    // Made the dots smaller to save space
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: active ? 16 : 10,
          height: active ? 16 : 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        color: active ? Colors.green : Colors.grey.shade200,
      ),
    );
  }
}
