import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/primary_button.dart';
import 'package:trackizer/common_widget/round_textfield.dart';
import 'package:trackizer/constants.dart';
import 'package:trackizer/dataadd.dart';

import '../../common_widget/image_button.dart';

class AddSubScriptionView extends StatefulWidget {
  const AddSubScriptionView({super.key});

  @override
  State<AddSubScriptionView> createState() => _AddSubScriptionViewState();
}

class _AddSubScriptionViewState extends State<AddSubScriptionView> {
  TextEditingController txtDescription = TextEditingController();
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  List subArr = [
    {"name": "Mutfak Alışverişi", "icon": "assets/img/kitchen.png", "ID": "1"},
    {"name": "Fatura", "icon": "assets/img/bill.png", "ID": "2"},
    {"name": "Restorant", "icon": "assets/img/restaurant.png", "ID": "3"},
    {"name": "Eğlence", "icon": "assets/img/laugh.png", "ID": "4"},
    {"name": "Ulaşım", "icon": "assets/img/transportation.png", "ID": "5"},
    {"name": "Kıyafet", "icon": "assets/img/clothes.png", "ID": "6"},
    {"name": "Sağlık", "icon": "assets/img/health.png", "ID": "7"},
    {"name": "Eğitim", "icon": "assets/img/education.png", "ID": "8"},
    {"name": "Hobi", "icon": "assets/img/hobbies.png", "ID": "9"},
  ];

  String name = 'Mutfak Alışverişi';
  String icon = 'assets/img/kitchen.png';
  double price = 0.0;
  String description = '';
  DateTime date = DateTime.now();
  int selectedIndex = 0;

  List<Expense> expenses = [];

  double amountVal = 0.00;
  DateTime? _selectedDate;
  bool isExpense =
      true; // Variable to track if the user is adding an expense or income

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference harcamalarcesiti =
        _database.collection('harcamacesitleri');
    final DocumentReference harcamacesitidoc =
        harcamalarcesiti.doc('jenKpsu3AQmyaeea6OZP');
    final CollectionReference harcamabilgisi =
        _database.collection('harcamabilgisi');
    final DocumentReference ahrcamabilgisidoc =
        harcamabilgisi.doc('TFia6fc8IMJHaNJP2jFF');

    final CollectionReference gelirbilgisi =
        _database.collection('gelirbilgisi');
    final DocumentReference gelirbilgisidoc =
        gelirbilgisi.doc('TFia6fc8IMJHaNJP2jGG');

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset("assets/img/back.png",
                                    width: 25,
                                    height: 25,
                                    color: TColor.gray30))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New",
                              style:
                                  TextStyle(color: TColor.gray30, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Yeni Bir Harcama Ekle ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      width: media.width,
                      height: media.width * 0.6,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.65,
                          enlargeFactor: 0.4,
                          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                          onPageChanged: (index, reason) {
                            setState(() {
                              selectedIndex = index;
                              name = subArr[selectedIndex]['name'];
                              icon = subArr[selectedIndex]['icon'];
                            });
                          },
                        ),
                        itemCount: subArr.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          var sObj = subArr[itemIndex] as Map? ?? {};
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  sObj["icon"],
                                  width: media.width * 0.4,
                                  height: media.width * 0.4,
                                  fit: BoxFit.fitHeight,
                                ),
                                const Spacer(),
                                Text(
                                  sObj["name"],
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpense = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? TColor.primary : TColor.gray30,
                    ),
                    child: Text('Harcamalar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpense = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? TColor.gray30 : TColor.primary,
                    ),
                    child: Text('Gelirler'),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: RoundTextField(
                  title: "Açıklama",
                  titleAlign: TextAlign.center,
                  controller: txtDescription,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(
                    image: "assets/img/minus.png",
                    onPressed: () {
                      amountVal -= 1;

                      if (amountVal < 0) {
                        amountVal = 0;
                      }

                      setState(() {});
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        "Fiyat",
                        style: TextStyle(
                            color: TColor.gray40,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "₺${amountVal.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 150,
                        height: 1,
                        color: TColor.gray70,
                      )
                    ],
                  ),
                  ImageButton(
                    image: "assets/img/plus.png",
                    onPressed: () {
                      amountVal += 1;

                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tarih Seç:',
                    style: TextStyle(
                      color: TColor.gray40,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : 'Tarih Seç',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                  title: isExpense ? "Harcama Ekle" : "Gelir Ekle",
                  onPressed: () async {
                    description = txtDescription.text;
                    try {
                      if (isExpense) {
                        FirebaseProcess().dataAdd(Expense(
                            name: name,
                            description: description,
                            price: amountVal,
                            icon: icon,
                            date: _selectedDate ?? DateTime.now()));
                      } else {
                        FirebaseProcess().incomeAdd(Income(
                            name: name,
                            description: description,
                            price: amountVal,
                            icon: icon,
                            date: _selectedDate ?? DateTime.now()));
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isExpense
                                ? "Harcama başarıyla eklendi"
                                : "Gelir başarıyla eklendi")),
                      );

                      txtDescription.clear();
                      setState(() {
                        amountVal = 0.00;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Hata: ${isExpense ? 'Harcama' : 'Gelir'} eklenemedi")),
                      );
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
