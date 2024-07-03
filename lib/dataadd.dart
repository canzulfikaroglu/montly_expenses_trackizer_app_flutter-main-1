import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/constants.dart';

class FirebaseProcess {
  final String aciklama = "";

  CollectionReference deneme1 =
      FirebaseFirestore.instance.collection('harcamabilgisi');
  Future<void> dataAdd(Expense expense) async {
    final FirebaseFirestore _database = FirebaseFirestore.instance;
    // Yeni bir harcama belgesi oluştur
    await _database.collection('harcamabilgisi').add({
      'isim': expense.name,
      'icon': expense.icon,
      'aciklama': expense.description,
      'fiyat': expense.price,
      'tarih': expense.date,
    });
  }

  Future<DocumentSnapshot> dataGet(String docId) async {
    return await deneme1.doc(docId).get();
  }
}
