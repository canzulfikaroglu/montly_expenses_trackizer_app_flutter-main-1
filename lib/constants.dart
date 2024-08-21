import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String name;
  double price;
  String description;
  String icon;
  String date;
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
      date: data['tarih'],
    );
  }
}

class Income {
  final String name;
  final String description;
  final double price;
  final String icon;
  final String date;

  Income({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.date,
  });

  factory Income.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Income(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      icon: data['icon'] ?? '',
      date: data['date'],
    );
  }
}
