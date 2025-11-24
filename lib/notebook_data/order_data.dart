import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  String mobileNo;
  String? consumerName;
  Timestamp? timestamp;
  String? locationLink;
  String? deliveryInstruction;
  String? timeSlot;
  int? quantity;
  String? status;
  int? totalAmount;
  List<NotebookOrder>? noteBookOrderList;
  double? lat;
  double? long;

  /// ✅ Factory method to return a fresh empty OrderData
  factory OrderData.empty() {
    return OrderData(
      mobileNo: '',
      consumerName: '',
      timestamp: Timestamp.now(),
      locationLink: '',
      deliveryInstruction: '',
      timeSlot: '',
      quantity: 0,
      status: '',
      lat: 0.0,
      long: 0.0,
      totalAmount: 0,
      noteBookOrderList: [],
    );
  }

  OrderData({
    required this.mobileNo,
    this.consumerName,
    this.timestamp,
    this.locationLink,
    this.deliveryInstruction,
    this.timeSlot,
    this.quantity,
    this.status,
    this.totalAmount,
    this.noteBookOrderList,
    this.lat,
    this.long,
  });

  /// ✅ Convert OrderData → Map (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      "mobileNo": mobileNo,
      "consumerName": consumerName,
      "timestamp": timestamp,
      "locationLink": locationLink,
      "deliveryInstruction": deliveryInstruction,
      "timeSlot": timeSlot,
      "quantity": quantity,
      "lat": lat,
      "long": long,
      "status": status,
      "totalAmount": totalAmount,
      "noteBookOrderList":
          noteBookOrderList?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  /// ✅ Create OrderData from Map (Firestore document snapshot)
  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      mobileNo: json["mobileNo"],
      consumerName: json["consumerName"],
      timestamp: json["timestamp"] as Timestamp,
      locationLink: json["locationLink"],
      deliveryInstruction: json["deliveryInstruction"],
      timeSlot: json["timeSlot"],
      quantity: json["quantity"],
      lat: json["lat"],
      long: json["long"],
      status: json["status"],
      totalAmount: json["totalAmount"],
      noteBookOrderList: (json["noteBookOrderList"] as List<dynamic>)
          .map((e) => NotebookOrder.fromJson(e))
          .toList(),
    );
  }

  /// ✅ Copy with new values (immutable style)
  OrderData copyWith({
    String? mobileNo,
    String? consumerName,
    Timestamp? timestamp,
    String? locationLink,
    String? deliveryInstruction,
    String? timeSlot,
    int? quantity,
    double? lat,
    double? long,
    String? status,
    int? totalAmount,
    List<NotebookOrder>? noteBookOrderList,
  }) {
    return OrderData(
      mobileNo: mobileNo ?? this.mobileNo,
      consumerName: consumerName ?? this.consumerName,
      timestamp: timestamp ?? this.timestamp,
      locationLink: locationLink ?? this.locationLink,
      deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
      timeSlot: timeSlot ?? this.timeSlot,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      noteBookOrderList: noteBookOrderList ?? this.noteBookOrderList,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  @override
  String toString() {
    return "OrderData(mobileNo: $mobileNo, consumerName: $consumerName, "
        "timestamp: $timestamp, totalAmount: $totalAmount, "
        "quantity: $quantity, status: $status, "
        "noteBookOrderList: $noteBookOrderList)";
  }
}

class NotebookOrder {
  String notebookGrade;
  String notebookType;
  String notebookName;

  /// page → { "quantity": x, "price": y }
  Map<String, Map<String, int>> pageQuantityMap;

  NotebookOrder({
    required this.notebookGrade,
    required this.notebookType,
    required this.notebookName,
    required this.pageQuantityMap,
  });

  factory NotebookOrder.empty() {
    return NotebookOrder(
      notebookGrade: '',
      notebookType: '',
      notebookName: '',
      pageQuantityMap: {},
    );
  }

  /// ✅ Convert NotebookOrder → Map (Firestore safe)
  Map<String, dynamic> toJson() {
    return {
      "notebookGrade": notebookGrade,
      "notebookType": notebookType,
      "notebookName": notebookName,
      "pageQuantityMap": pageQuantityMap, // already String keys
    };
  }

  /// ✅ Create NotebookOrder from Map
  factory NotebookOrder.fromJson(Map<String, dynamic> json) {
    return NotebookOrder(
      notebookGrade: json["notebookGrade"] ?? '',
      notebookType: json["notebookType"] ?? '',
      notebookName: json["notebookName"] ?? '',
      pageQuantityMap: (json["pageQuantityMap"] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, Map<String, int>.from(v)),
      ),
    );
  }

  NotebookOrder copyWith({
    String? notebookGrade,
    String? notebookType,
    String? notebookName,
    Map<String, Map<String, int>>? pageQuantityMap,
  }) {
    return NotebookOrder(
      notebookGrade: notebookGrade ?? this.notebookGrade,
      notebookType: notebookType ?? this.notebookType,
      notebookName: notebookName ?? this.notebookName,
      pageQuantityMap: pageQuantityMap ?? this.pageQuantityMap,
    );
  }
}
