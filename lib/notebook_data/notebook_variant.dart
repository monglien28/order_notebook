import 'package:cloud_firestore/cloud_firestore.dart';

class NotebookVariant {
  final String id;
  final String typeId;
  final String typeName;
  final String gradeId;
  final String gradeName;
  final List<String> imageUrls; // multiple images
  final bool isActive;
  final Map<String, int> pageAvailable; // ✅ pages (string) -> price

  NotebookVariant({
    required this.id,
    required this.typeId,
    required this.typeName,
    required this.gradeId,
    required this.gradeName,
    required this.imageUrls,
    required this.isActive,
    required this.pageAvailable,
  });

  /// Factory to create from Firestore
  factory NotebookVariant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    // Convert List<Map> into Map<String, int>
    Map<String, int> pageMap = {};
    if (data['pageAvailable'] != null) {
      final List<dynamic> list = data['pageAvailable'];
      for (var entry in list) {
        if (entry is Map) {
          entry.forEach((key, value) {
            pageMap[key.toString()] = value as int;
          });
        }
      }
    }

    return NotebookVariant(
      id: doc.id,
      typeId: data['typeId'] ?? '',
      typeName: data['typeName'] ?? '',
      gradeId: data['gradeId'] ?? '',
      gradeName: data['gradeName'] ?? '',
      imageUrls: List<String>.from(data['imageUrl'] ?? []),
      isActive: data['isActive'] ?? true,
      pageAvailable: pageMap,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'typeName': typeName,
      'gradeId': gradeId,
      'gradeName': gradeName,
      'imageUrl': imageUrls,
      'isActive': isActive,
      'pageAvailable': pageAvailable.entries
          .map((e) => {e.key: e.value}) // keep keys as String
          .toList(),
    };
  }
}
