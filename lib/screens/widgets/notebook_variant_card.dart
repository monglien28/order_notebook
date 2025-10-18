import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_notebook/app_theme.dart';
import 'package:order_notebook/notebook_data/notebook_variant.dart';
import 'package:order_notebook/notebook_data/order_data.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';
import 'package:order_notebook/screens/widgets/notebook_description.dart';
import 'package:order_notebook/screens/widgets/notebook_variant_image_slider.dart';
import 'package:order_notebook/screens/widgets/page_selection_widget.dart';

class NotebookVariantCard extends ConsumerStatefulWidget {
  const NotebookVariantCard({super.key, required this.notebookVariant});
  final NotebookVariant notebookVariant;

  @override
  ConsumerState<NotebookVariantCard> createState() =>
      _NotebookVariantCardState();
}

class _NotebookVariantCardState extends ConsumerState<NotebookVariantCard>
    with AutomaticKeepAliveClientMixin {
  late NotebookOrder notebookOrder;

  @override
  void initState() {
    super.initState();

    // initialize pageQuantityMap with 0 quantity but price filled
    notebookOrder = NotebookOrder(
      notebookGrade: widget.notebookVariant.gradeId,
      notebookType: widget.notebookVariant.typeId,
      notebookName: widget.notebookVariant.typeName,

      pageQuantityMap: {
        for (var entry in widget.notebookVariant.pageAvailable.entries)
          entry.key: {"quantity": 0, "price": entry.value},
      },
    );

    ref.read(selectedVariantListProvider.notifier).state.add(notebookOrder);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      color: kBeigeLight,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: NotebookVariantImageSlider(
              imageUrls: widget.notebookVariant.imageUrls,
            ),
          ),
          SizedBox(
            height: 80,
            child: NotebookInfoCard(
              typeName: widget.notebookVariant.typeName,
              gradeName: widget.notebookVariant.gradeName,
            ),
          ),
          PageSelectionWidget(
            pageOptions: widget.notebookVariant.pageAvailable.keys.toList(),
            onSelectionChanged: onItemCountChanged,
            existingQuantities: {
              for (var e in notebookOrder.pageQuantityMap.entries)
                e.key: e.value["quantity"] ?? 0,
            },
            pagePrice: widget.notebookVariant.pageAvailable,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void onItemCountChanged(String pagecount, int quantity, int price) {
    ref.watch(selectedVariantListProvider.notifier).update((state) {
      final updatedList = [...state];

      final index = updatedList.indexWhere(
        (element) =>
            element.notebookType == widget.notebookVariant.typeId &&
            element.notebookGrade == widget.notebookVariant.gradeId,
      );

      if (index != -1) {
        if (quantity > 0) {
          final oldMap = Map<String, Map<String, int>>.from(
            updatedList[index].pageQuantityMap,
          );
          oldMap[pagecount] = {"quantity": quantity, "price": price};

          updatedList[index] = updatedList[index].copyWith(
            pageQuantityMap: oldMap,
          );
        } else {
          final oldMap = Map<String, Map<String, int>>.from(
            updatedList[index].pageQuantityMap,
          );
          oldMap.remove(pagecount);
          updatedList[index] = updatedList[index].copyWith(
            pageQuantityMap: oldMap,
          );
        }
      }

      // ✅ After updating, recalc total price
      int newTotalPrice = 0;
      for (final order in updatedList) {
        for (final entry in order.pageQuantityMap.values) {
          final q = entry["quantity"] ?? 0;
          final p = entry["price"] ?? 0;
          newTotalPrice += q * p;
        }
      }
      ref.read(totalPriceProvider.notifier).state = newTotalPrice;

      return updatedList;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
