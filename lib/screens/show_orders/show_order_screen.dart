import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/screens/show_orders/order_model_data.dart';
import 'package:order_notebook/screens/show_orders/show_orders_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.mobileNo});
  final String mobileNo;

  @override
  Widget build(BuildContext context) {
    final ordersQuery = FirebaseFirestore.instance
        .collection('orders')
        .where('mobileNo', isEqualTo: mobileNo)
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 180, 136, 1),
      // backgroundColor: Theme.of(
      //   context,
      // ).colorScheme.onPrimary, // Modern off-white background
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(207, 184, 140, 1),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ordersQuery.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          final orders = snap.data!.docs
              .map((d) => OrderModel.fromFirestore(d))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => OrderCard(order: orders[i]),
          );
        },
      ),
    );
  }
}
