import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_notebook/notebook_data/page_selection_data.dart';

class PageSelectionWidget extends ConsumerStatefulWidget {
  final List<String> pageOptions;
  final Function(String page, int quantity, int price) onSelectionChanged;
  final Map<String, int> existingQuantities; // page → quantity
  final Map<String, int> pagePrice; // page → price

  const PageSelectionWidget({
    super.key,
    required this.pageOptions,
    required this.onSelectionChanged,
    required this.existingQuantities,
    required this.pagePrice,
  });

  @override
  ConsumerState<PageSelectionWidget> createState() =>
      _PageSelectionWidgetState();
}

class _PageSelectionWidgetState extends ConsumerState<PageSelectionWidget> {
  late List<SelectedPageQuantity> selectedQuantities;

  @override
  void initState() {
    super.initState();
    selectedQuantities = widget.pageOptions.map((pages) {
      return SelectedPageQuantity(
        pages: pages,
        quantity: widget.existingQuantities[pages] ?? 0,
      );
    }).toList();
  }

  void _updateQuantity(int index, int change, String page, int price) {
    setState(() {
      final newQuantity = selectedQuantities[index].quantity + change;
      if (newQuantity >= 0) {
        selectedQuantities[index].quantity = newQuantity;
      }
    });

    // ✅ Notify parent with page, quantity, and price
    widget.onSelectionChanged(page, selectedQuantities[index].quantity, price);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        key: ValueKey(widget.pageOptions),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.pageOptions.length, (index) {
          final item = selectedQuantities[index];
          final itemPrice = widget.pagePrice[item.pages]!;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: Color.fromRGBO(255, 248, 231, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Color.fromRGBO(255, 248, 231, 1),
                  elevation: 0,
                  child: Text(
                    '$itemPrice ₹',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromRGBO(255, 248, 231, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "${item.pages} pages",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () =>
                              _updateQuantity(index, -1, item.pages, itemPrice),
                        ),
                        Text(
                          "${item.quantity}",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () =>
                              _updateQuantity(index, 1, item.pages, itemPrice),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
