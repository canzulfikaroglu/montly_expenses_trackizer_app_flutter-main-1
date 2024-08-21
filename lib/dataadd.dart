import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/constants.dart';

class FirebaseProcess {
  Future<void> dataAdd(Expense expense) async {
    final FirebaseFirestore database = FirebaseFirestore.instance;

    // Yeni bir harcama belgesi oluştur
    await database.collection('harcamabilgisi').add({
      'isim': expense.name,
      'icon': expense.icon,
      'aciklama': expense.description,
      'fiyat': expense.price,
      'tarih': expense.date,
    });
  }

  Future<void> incomeAdd(Income income) async {
    final FirebaseFirestore database = FirebaseFirestore.instance;

    // Yeni bir harcama belgesi oluştur
    await database.collection('gelirler').add({
      'name': income.name,
      'icon': income.icon,
      'description': income.description,
      'price': income.price,
      'date': income.date,
    });
  }
}
