import 'package:flutter/material.dart';
import 'package:order_notebook/notebook_data/notebook_variant.dart';
import 'package:order_notebook/screens/widgets/notebook_variant_card.dart';

class NotebookShowPage extends StatefulWidget {
  final String noteBookName;
  final List<NotebookVariant> notebookVariant;

  const NotebookShowPage({
    super.key,
    required this.noteBookName,
    required this.notebookVariant,
  });

  @override
  State<NotebookShowPage> createState() => _NotebookShowPageState();
}

class _NotebookShowPageState extends State<NotebookShowPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(255, 248, 231, 1),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text(
            widget.noteBookName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.notebookVariant.length,
              itemBuilder: (context, index) => NotebookVariantCard(
                notebookVariant: widget.notebookVariant[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
