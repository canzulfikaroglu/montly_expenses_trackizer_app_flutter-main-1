import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/budgets_row.dart';
import 'package:trackizer/common_widget/custom_arc_180_painter.dart';

import '../settings/settings_view.dart';

class SpendingBudgetsView extends StatefulWidget {
  const SpendingBudgetsView({super.key});

  @override
  State<SpendingBudgetsView> createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  List budgetArr = [
    {
      "name": "Yeni araba",
      "icon": "assets/img/auto_&_transport.png",
      "saved_budget": "15000",
      "total_budget": "500000",
      "left_amount": "100", //fiyattan biriktirilen miktar çıkarılacak
      "color": TColor.secondaryG
    },
    {
      "name": "Yeni ev",
      "icon": "assets/img/entertainment.png",
      "saved_budget": "15000",
      "total_budget": "1150000",
      "left_amount": "100",
      "color": TColor.secondary50
    },
    {
      "name": "Yeni telefon",
      "icon": "assets/img/security.png",
      "saved_budget": "500",
      "total_budget": "20000",
      "left_amount": "100",
      "color": TColor.primary10
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35, right: 10),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsView()));
                      },
                      icon: Image.asset("assets/img/settings.png",
                          width: 25, height: 25, color: TColor.gray30))
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: media.width * 0.5,
                  height: media.width * 0.30,
                  child: CustomPaint(
                    painter: CustomArc180Painter(
                      drwArcs: [
                        ArcValueModel(color: TColor.secondaryG, value: 20),
                        ArcValueModel(color: TColor.secondary, value: 45),
                        ArcValueModel(color: TColor.primary10, value: 70),
                      ],
                      end: 50,
                      width: 12,
                      bgWidth: 8,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "5000\₺", //aylık toplam harcamayı gösterecek
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    // Text(
                    //   "of 2,0000 budget\₺",//buraya gerek yok
                    //   style: TextStyle(
                    //       color: TColor.gray30,
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500),
                    // ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TColor.border.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " hedefleriniz doğrultusunda ilerliyorsunuz 👍", // hedeflerle ilgili bir şey yazıcam

                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: budgetArr.length,
                itemBuilder: (context, index) {
                  var bObj = budgetArr[index] as Map? ?? {};

                  return BudgetsRow(
                    bObj: bObj,
                    onPressed: () {},
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  //yeni hedef ekleme butonu
                  print("can");
                },
                child: DottedBorder(
                  dashPattern: const [5, 4],
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  color: TColor.border.withOpacity(0.1),
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Yeni bir hedef ekle ",
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          "assets/img/add.png",
                          width: 12,
                          height: 12,
                          color: TColor.gray30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 110,
            ),
          ],
        ),
      ),
    );
  }
}
