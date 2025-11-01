import 'package:flutter/material.dart';

class NotebookInfoCard extends StatelessWidget {
  final String typeName;
  final String gradeName;

  const NotebookInfoCard({
    super.key,
    required this.typeName,
    required this.gradeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 239, 202),

        // gradient: LinearGradient(
        //   colors: [Colors.blue.shade50, Colors.blue.shade100],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              typeName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(92, 64, 51, 1),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              "Grade: $gradeName",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color.fromRGBO(88, 75, 58, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
