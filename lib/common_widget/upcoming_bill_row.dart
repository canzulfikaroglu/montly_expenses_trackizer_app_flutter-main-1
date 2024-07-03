import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class IncomeEntryView extends StatefulWidget {
  const IncomeEntryView({super.key});

  @override
  State<IncomeEntryView> createState() => _IncomeEntryViewState();
}

class _IncomeEntryViewState extends State<IncomeEntryView> {
  List<Map<String, dynamic>> incomeArr = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void addNewIncome() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Gelir Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Gelir Adı'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Gelir Tutarı'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ekle'),
              onPressed: () {
                setState(() {
                  incomeArr.add({
                    "name": nameController.text,
                    "price": double.parse(priceController.text),
                  });
                });
                Navigator.of(context).pop();
                // TextField'ları temizleyin
                nameController.clear();
                priceController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  double getTotalIncome() {
    return incomeArr.fold(0, (sum, item) => sum + item["price"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelir Girişi'),
      ),
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: addNewIncome,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: TColor.primary10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Yeni bir gelir ekle ",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: TColor.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Toplam Gelir:',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${getTotalIncome().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: incomeArr.length,
              itemBuilder: (context, index) {
                var income = incomeArr[index];
                return UpcomingBillRow(
                  sObj: income,
                  onPressed: () {
                    // Gelir detayları ya da düzenleme için işlemler yapılabilir
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingBillRow extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const UpcomingBillRow(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Jun",
                      style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "25",
                      style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  sObj["name"],
                  style: TextStyle(
                      color: TColor.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "\$${sObj["price"]}",
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
