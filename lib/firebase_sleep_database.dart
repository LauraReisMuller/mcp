import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSleepDatabase {
  static final _collection = FirebaseFirestore.instance.collection('sleepRecords');

  static Future<List<Map<String, dynamic>>> getAllRecords() async {
    final querySnapshot = await _collection.orderBy('date', descending: true).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      // Convert Firestore Timestamp to DateTime
      if (data['date'] is Timestamp) {
        data['date'] = (data['date'] as Timestamp).toDate();
      }
      return data;
    }).toList();
  }

  static Future<void> addRecord(Map<String, dynamic> record) async {
    // Ensure 'date' is a DateTime
    if (record['date'] is! DateTime) {
      record['date'] = DateTime.now();
    }
    await _collection.add(record);
  }
}
