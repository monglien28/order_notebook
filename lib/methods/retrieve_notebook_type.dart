import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getNotebookTypes() async {
  try {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection("notebookTypes")
        .where("isActive", isEqualTo: true)
        .get();

    List<String> types = snapshot.docs
        .map((doc) => doc.data()["name"] as String)
        .toList();

    return types;
  } catch (e) {
    throw Exception(e);
  }
}
