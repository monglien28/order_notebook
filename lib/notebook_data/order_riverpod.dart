import 'package:flutter_riverpod/legacy.dart';
import 'package:order_notebook/notebook_data/consumer_data.dart';
import 'package:order_notebook/notebook_data/order_data.dart';

final orderProvider = StateProvider<OrderData>((ref) => OrderData.empty());
final selectedVariantListProvider = StateProvider<List<NotebookOrder>>(
  (ref) => [],
);
final totalPriceProvider = StateProvider<int>((ref) => 0);

final consumerProvider = StateProvider<ConsumerData>((ref) => ConsumerData.empty());

// Reset to null
// ref.read(orderProvider.notifier).state = null;

// Or set a fresh empty object
//
