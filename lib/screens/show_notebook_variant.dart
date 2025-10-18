import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/main.dart';
import 'package:order_notebook/notebook_data/notebook_variant.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';
import 'package:order_notebook/screens/checkout_page/checkout_screen.dart';
import 'package:order_notebook/screens/widgets/notebook_show_page.dart';

class ShowNotebookVariant extends ConsumerStatefulWidget {
  const ShowNotebookVariant({super.key, required this.notebookVariantMap});

  final Map<String, List<NotebookVariant>> notebookVariantMap;

  @override
  ConsumerState<ShowNotebookVariant> createState() =>
      _ShowNotebookVariantState();
}

class _ShowNotebookVariantState extends ConsumerState<ShowNotebookVariant> {
  int currentIndex = 0;
  bool loader = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.notebookVariantMap.entries.toList();

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: entries.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (ctx, index) {
                    return NotebookShowPage(
                      noteBookName: entries[index].key,
                      notebookVariant: entries[index].value,
                    );
                  },
                ),
              ),

              // --- Navigation Buttons ---
              Container(
                color: const Color.fromARGB(255, 156, 127, 70),
                padding: const EdgeInsets.all(12.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total Price : ${ref.watch(totalPriceProvider)}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 7, 47, 13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (currentIndex > 0)
                        ElevatedButton.icon(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Previous"),
                        ),
                      SizedBox(width: 10),
                      if (currentIndex < entries.length - 1)
                        ElevatedButton.icon(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next"),
                        ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: onGoToCartClick,
                        label: const Text('Complete Order'),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (loader) const LoadingWidget(),
      ],
    );
  }

  void onGoToCartClick() {
    try {
      if (getTotalSelectedQuantity() < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least 2 items !!!")),
        );
        return;
      }

      ref.read(selectedVariantListProvider.notifier).update((orders) {
        return orders
            .map((order) {
              // ✅ Clean pageQuantityMap: remove pages with quantity == 0
              final cleanedPageMap = Map<String, Map<String, int>>.from(
                order.pageQuantityMap,
              )..removeWhere((_, value) => (value["quantity"] ?? 0) == 0);

              return order.copyWith(pageQuantityMap: cleanedPageMap);
            })
            // ✅ Keep only orders with at least one valid page
            .where((order) => order.pageQuantityMap.isNotEmpty)
            .toList();
      });

      // ✅ Save only filtered orders into orderProvider
      ref.read(orderProvider.notifier).update((order) {
        return order.copyWith(
          timestamp: Timestamp.now(),
          quantity: getTotalSelectedQuantity(),
          status: "pending",
          totalAmount: ref.read(totalPriceProvider),
          noteBookOrderList: ref.read(
            selectedVariantListProvider,
          ), // ✅ only non-zero saved
        );
      });

      // print(ref.read(orderProvider));
      // print(ref.read(selectedVariantListProvider));

      // Navigate to Cart Page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => AppContainer(child: CartPage())),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong !!!")));
    }
  }

  int getTotalSelectedQuantity() {
    final notebookOrders = ref.read(selectedVariantListProvider);
    int total = 0;

    for (final order in notebookOrders) {
      for (final pageData in order.pageQuantityMap.values) {
        total += pageData["quantity"] ?? 0;
      }
    }

    return total;
  }

  // int getTotalPrice() {
  //   final notebookOrders = ref.read(selectedVariantListProvider);
  //   int totalPrice = 0;

  //   for (final order in notebookOrders) {
  //     for (final pageData in order.pageQuantityMap.values) {
  //       final qty = pageData["quantity"] ?? 0;
  //       final price = pageData["price"] ?? 0;
  //       totalPrice += qty * price;
  //     }
  //   }

  //   return totalPrice;
  // }

  void updateTotalPrice() {
    final notebookOrders = ref.read(selectedVariantListProvider);
    int total = 0;

    for (final order in notebookOrders) {
      for (final pageData in order.pageQuantityMap.values) {
        final qty = pageData["quantity"] ?? 0;
        final price = pageData["price"] ?? 0;
        total += qty * price;
      }
    }

    // ✅ update Riverpod state
    ref.read(totalPriceProvider.notifier).state = total;
  }
}
