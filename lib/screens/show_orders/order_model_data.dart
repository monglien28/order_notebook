// ----------------------------- Data models -----------------------------
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final DateTime timestamp;
  final String status;
  final String consumerName;
  final String mobileNo;
  final int totalAmount;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.consumerName,
    required this.mobileNo,
    required this.totalAmount,
    required this.items,
  });

  int get totalQuantity => items.fold(0, (s, item) => s + item.quantity);

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rawItems = (data['noteBookOrderList'] as List<dynamic>?) ?? [];

    final items = <OrderItem>[];
    for (final r in rawItems) {
      try {
        final map = Map<String, dynamic>.from(r as Map);
        final name =
            map['notebookName']?.toString() ??
            map['notebookType'] ??
            'Notebook';
        final grade = map['notebookGrade']?.toString() ?? '';
        final pageQuantityMapRaw = map['pageQuantityMap'] ?? {};
        final pqp = <int, PageData>{};
        if (pageQuantityMapRaw is Map) {
          pageQuantityMapRaw.forEach((k, v) {
            final pageKey = int.tryParse(k.toString()) ?? (k is int ? k : 0);
            if (v is Map) {
              final qty = (v['quantity'] ?? v['Quantity'] ?? 0) as int;
              final price = (v['price'] ?? v['Price'] ?? 0) as int;
              pqp[pageKey] = PageData(quantity: qty, price: price);
            }
          });
        }
        pqp.forEach((page, pd) {
          if (pd.quantity > 0) {
            items.add(
              OrderItem(
                notebookName: name,
                notebookGrade: grade,
                pages: page,
                quantity: pd.quantity,
                pricePerUnit: pd.price,
              ),
            );
          }
        });
      } catch (_) {}
    }

    final ts = data['timestamp'];
    DateTime timestamp = DateTime.now();
    if (ts is Timestamp) {
      timestamp = ts.toDate();
    } else if (ts is String) {
      try {
        timestamp = DateTime.parse(ts);
      } catch (_) {}
    }

    return OrderModel(
      id: doc.id,
      timestamp: timestamp,
      status: (data['status'] ?? 'ordered').toString(),
      consumerName: (data['consumerName'] ?? data['name'] ?? '').toString(),
      mobileNo: (data['mobileNo'] ?? '').toString(),
      totalAmount: (data['totalAmount'] ?? 0) as int,
      items: items,
    );
  }
}

class PageData {
  final int quantity;
  final int price;
  PageData({required this.quantity, required this.price});
}

class OrderItem {
  final String notebookName;
  final String notebookGrade;
  final int pages;
  final int quantity;
  final int pricePerUnit;

  OrderItem({
    required this.notebookName,
    required this.notebookGrade,
    required this.pages,
    required this.quantity,
    required this.pricePerUnit,
  });
}
