import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_notebook/notebook_data/notebook_variant.dart';

Future<List<NotebookVariant>> getVariantsByTypeName(String typeName) async {
  final firestore = FirebaseFirestore.instance;

  final snapshot = await firestore
      .collection("notebookVariants")
      .where("typeName", isEqualTo: typeName)
      .where("isActive", isEqualTo: true)
      .get();


  return snapshot.docs
      .map((doc) => NotebookVariant.fromFirestore(doc))
      .toList();
}
