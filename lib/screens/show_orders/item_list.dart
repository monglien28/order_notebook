import 'package:flutter/material.dart';
import 'package:order_notebook/screens/show_orders/order_model_data.dart';

class ItemsList extends StatelessWidget {
  final OrderModel order;
  const ItemsList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // group by notebookName+grade
    final groups = <String, List<OrderItem>>{};
    for (final it in order.items) {
      final key = '${it.notebookName}|${it.notebookGrade}';
      groups.putIfAbsent(key, () => []).add(it);
    }

    return Column(
      children: groups.entries.map((e) {
        final label = e.key.split('|');
        final name = label[0];
        final grade = label[1];
        final entries = e.value;

        // "Compact Row" Layout: Name on left, variants stacked tightly on right
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Notebook Name & Grade
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Icon(Icons.book, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            if (grade.isNotEmpty)
                              TextSpan(
                                text: '  •  $grade',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right: Tightly packed variants
              Expanded(
                flex: 3,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 4,
                  runSpacing: 4,
                  children: entries.map((it) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${it.pages}p × ${it.quantity}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
