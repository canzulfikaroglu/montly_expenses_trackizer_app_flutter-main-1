import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String name;
  double price;
  String description;
  String icon;
  DateTime date;
  Expense(
      {required this.name,
      required this.description,
      required this.price,
      required this.icon,
      required this.date});
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Expense(
      name: data['isim'] ?? '',
      description: data['aciklama'] ?? '',
      price: data['fiyat']?.toDouble() ?? 0.0,
      icon: data['icon'] ?? '',
      date: (data['tarih'] as Timestamp).toDate(),
    );
  }
}
