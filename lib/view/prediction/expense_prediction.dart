import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpensePrediction extends StatefulWidget {
  const ExpensePrediction({Key? key}) : super(key: key);

  @override
  State<ExpensePrediction> createState() => _ExpensePredictionState();
}

class _ExpensePredictionState extends State<ExpensePrediction> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tahmin sonuçlarını tutmak için bir liste
  List<Map<String, dynamic>> predictions = [];

  @override
  void initState() {
    super.initState();
    fetchPredictions();
  }

  Future<void> fetchPredictions() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('tahmin_sonuclari').get();
      setState(() {
        predictions = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching predictions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(51, 130, 178, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  var prediction = predictions[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text(prediction['harcama_turu']),
                      subtitle: Text(
                          'Tahmin: ${prediction['tahmin']} TL\nMSE: ${prediction['mse']}'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 70.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
