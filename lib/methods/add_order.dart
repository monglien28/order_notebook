import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_notebook/notebook_data/order_data.dart';
Future<void> saveOrder(OrderData order) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection("orders").add(order.toJson());
  } catch (e) {
    rethrow;
  }
}


