import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addConsumer(String name, String mobile, int totalOrders) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection("consumers").doc(mobile);

    // Create new
    await docRef.set({
      "name": name,
      "mobileNo": mobile,
      // "lastAddress": lastAddress,
      "totalOrders": totalOrders,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  } catch (e) {
    rethrow;
  }
}

Future<void> addMobileNo(String mobileNo) async {
  try {
    final docRef = FirebaseFirestore.instance
        .collection("consumers")
        .doc(mobileNo);
    final doc = await docRef.get();

    if (!doc.exists) {
      // create the consumer document
      await docRef.set({
        "mobileNo": mobileNo,
        "totalOrders": 0, // start with 0
        "createdAt": FieldValue.serverTimestamp(),
      });

      return;
    }
  } catch (e) {
    rethrow;
  }
}

// Future<void> updateConsumerAddress(String mobile) async {
//   try {
//     final firestore = FirebaseFirestore.instance;
//     final docRef = firestore.collection("consumers").doc(mobile);

//     final snapshot = await docRef.get();
//     if (snapshot.exists) {
//       // Update existing
//       await docRef.update({
//         // "lastAddress": lastAddress,
//         "updatedAt": FieldValue.serverTimestamp(),
//       });
//     }
//   } catch (e) {
//     rethrow;
//   }
// }

Future<Map<String, dynamic>> checkConsumerExist(String mobile) async {
  try {
    Map<String, dynamic> result = {};

    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection("consumers").doc(mobile);

    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data()!;

      // Safely get name, default to "Unknown" if not present
      final name = data.containsKey("name") ? data["name"] as String : "";
      result['name'] = name;

      // Safely get totalOrders, default to 0 if not present
      final totalOrders = data.containsKey("totalOrders")
          ? data["totalOrders"] as int
          : 0;
      result['totalOrders'] = totalOrders;

      result;
    }

    return result;
  } catch (e) {
    throw Exception("Error checking consumer: $e");
  }
}
