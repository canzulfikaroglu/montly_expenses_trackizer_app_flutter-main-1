import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/constants.dart';

class FirebaseProcess {
  final String aciklama = "";
  CollectionReference gelir = FirebaseFirestore.instance.collection('gelirler');
  CollectionReference harcama =
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
    return await harcama.doc(docId).get();
  }

  Future<DocumentSnapshot> dataGetincome(String docId) async {
    return await gelir.doc(docId).get();
  }

  Future<void> incomeAdd(Income income) async {
    final FirebaseFirestore _database = FirebaseFirestore.instance;
    // Yeni bir harcama belgesi oluştur
    await _database.collection('gelirler').add({
      'name': income.name,
      'icon': income.icon,
      'description': income.description,
      'price': income.price,
      'date': income.date,
    });
  }
}
