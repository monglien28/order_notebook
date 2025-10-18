class ConsumerData {
  String mobileNo;
  String name;
  int totalOrders;

  ConsumerData({
    required this.mobileNo,
    required this.name,
    required this.totalOrders,
  });

  factory ConsumerData.fromMap(Map<String, dynamic> map) {
    return ConsumerData(
      mobileNo: map['mobileNo'] ?? '',
      name: map['name'] ?? '',
      totalOrders: map['totalOrders'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'mobileNo': mobileNo, 'name': name, 'totalOrders': totalOrders};
  }

  factory ConsumerData.empty() {
    return ConsumerData(mobileNo: '', name: '', totalOrders: 0);
  }
}
