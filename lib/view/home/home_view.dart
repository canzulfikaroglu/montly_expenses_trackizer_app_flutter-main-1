import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/constants.dart';
import '../../common_widget/custom_arc_painter.dart';
import '../../common_widget/segment_button.dart';
import '../../common_widget/status_button.dart';
import '../../common_widget/subscription_home_row.dart';
import '../settings/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSubscription = true;
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  List<Expense> expenses = [];
  List<Income> incomes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
    fetchIncomes();
  }

  Future<void> fetchExpenses() async {
    final CollectionReference harcamabilgisi =
        _database.collection('harcamabilgisi');
    final QuerySnapshot querySnapshot = await harcamabilgisi.get();
    setState(() {
      expenses =
          querySnapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
      isLoading = false;
    });
  }

  Future<void> fetchIncomes() async {
    final CollectionReference gelirbilgisi = _database.collection('gelirler');
    final QuerySnapshot querySnapshot = await gelirbilgisi.get();
    setState(() {
      incomes =
          querySnapshot.docs.map((doc) => Income.fromFirestore(doc)).toList();
      isLoading = false;
    });
  }

  Expense? getHighestExpense() {
    if (expenses.isEmpty) {
      return null;
    }
    Expense highestExpense = expenses[0];
    for (var expense in expenses) {
      if (expense.price > highestExpense.price) {
        highestExpense = expense;
      }
    }
    return highestExpense;
  }

  Expense? getLowestExpense() {
    if (expenses.isEmpty) {
      return null;
    }
    Expense lowestExpense = expenses[0];
    for (var expense in expenses) {
      if (expense.price < lowestExpense.price) {
        lowestExpense = expense;
      }
    }
    return lowestExpense;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    var highestExpense = getHighestExpense();
    var highestExpenseValue = highestExpense?.price.toString() ?? "Yok";
    var lowestExpense = getLowestExpense();
    var lowestExpenseValue = lowestExpense?.price.toString() ?? "Yok";

    return Scaffold(
      backgroundColor: const Color.fromARGB(51, 130, 178, 255),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: media.width * 1.1,
                    decoration: BoxDecoration(
                        color: TColor.gray70.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/img/home_bg.png"),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(bottom: media.width * 0.05),
                              width: media.width * 0.72,
                              height: media.width * 0.72,
                              child: CustomPaint(
                                painter: CustomArcPainter(
                                  end: 220,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SettingsView()));
                                      },
                                      icon: Image.asset(
                                          "assets/img/settings.png",
                                          width: 25,
                                          height: 25,
                                          color: TColor.gray30))
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Image.asset("assets/img/app_logo.png",
                                width: media.width * 0.25, fit: BoxFit.contain),
                            SizedBox(
                              height: media.width * 0.07,
                            ),
                            Text(
                              "", //günlük toplam harcama burda yazılacak
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: media.width * 0.055,
                            ),
                            Text(
                              "Bu Ay Yapılan Harcamalar",
                              style: TextStyle(
                                  color: TColor.gray40,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: media.width * 0.07,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: TColor.border.withOpacity(0.15),
                                  ),
                                  color: TColor.gray60.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "Bakiyeni Gör!",
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: StatusButton(
                                      title: "Harcamalar",
                                      value: expenses.length.toString(),
                                      statusColor: TColor.secondary,
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: StatusButton(
                                      title: "En Yüksek Harcama",
                                      value: highestExpenseValue,
                                      statusColor: TColor.primary10,
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: StatusButton(
                                      title: "En Düşük Harcama",
                                      value: lowestExpenseValue,
                                      statusColor: TColor.secondaryG,
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: SegmentButton(
                            title: "Harcamaların",
                            isActive: isSubscription,
                            onPressed: () {
                              setState(() {
                                isSubscription = !isSubscription;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SegmentButton(
                            title: "Gelirlerin",
                            isActive: !isSubscription,
                            onPressed: () {
                              setState(() {
                                isSubscription = !isSubscription;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  if (isSubscription)
                    ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          var expense = expenses[index];

                          return SubScriptionHomeRow(
                            sObj: {
                              'name': expense.name,
                              'description': expense.description,
                              'price': expense.price,
                              'icon': expense.icon,
                              'date': expense.date
                            },
                            onPressed: () {},
                          );
                        }),
                  if (!isSubscription)
                    ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: incomes.length,
                        itemBuilder: (context, index) {
                          var income = incomes[index];

                          return SubScriptionHomeRow(
                            sObj: {
                              'name': income.name,
                              'description': income.description,
                              'price': income.price,
                              'icon': income.icon,
                              'date': income.date,
                            },
                            onPressed: () {},
                          );
                        }),
                  const SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
    );
  }
}
