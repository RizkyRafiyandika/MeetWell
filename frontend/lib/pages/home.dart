import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/catagory_model.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:fitness2/models/diet_model.dart';
import 'package:fitness2/models/popular_model.dart';
import 'package:fitness2/pages/CategoryDetailPage.dart';
import 'package:fitness2/pages/settingPage.dart';
import 'package:fitness2/widgets/myBalance.dart';
import 'package:fitness2/widgets/myCardFood.dart';
import 'package:fitness2/widgets/myNavigationMenu.dart';
import 'package:flutter/material.dart';
import 'package:fitness2/services/diet_service.dart';
import 'package:fitness2/widgets/top_up.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  String username = "Guest";
  double balance = 0.0; // Default balance

  List<CategoryModel> categories = [];

  List<DietModel> diets = [];

  List<PopularDietsModel> popularDiets = [];

  List<PopularDietsModel> _foundPopularDiets = [];

  Future<void> _getinsection() async {
    try {
      categories = CategoryModel.getCategories();
      diets = DietModel.getDiet();
      popularDiets = await DietService().fetchPopularDiets();
      _foundPopularDiets = popularDiets; // Set the initial data for search
      setState(() {}); // Ensure the UI is updated after fetching data
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchDataUsers() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid; //uid user saat login

        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc["username"];
            balance = userDoc["balance"];
          });
        }
      }
    } catch (e) {
      print("error fetching user data: $e");
    }
  }

  void _updateBalance(double amount) {
    setState(() {
      balance += amount;
    });
  }

  Future<void> _handleRefresh() async {
    await _getinsection();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _fetchDataUsers(),
      _getinsection(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: MyAppDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: [
            // Balance Widget
            BalanceWidget(
              username: username,
              balance: balance,
              onTopUp: () => showTopUpDialog(context, _updateBalance),
            ),
            _categoriesSection(categories: categories),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: tdcyan.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _searchBar(),
                    const SizedBox(height: 10),
                    _popularSection(context),
                    _dietSection(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<PopularDietsModel> result = [];
    if (enteredKeyword.isEmpty) {
      result = popularDiets;
    } else {
      result = popularDiets
          .where((item) =>
              item.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundPopularDiets = result; // Update UI with the filtered list
    });
  }

  Column _popularSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Popular',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        if (_foundPopularDiets.isEmpty)
          Center(
            child: Text(
              'No products found',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          )
        else
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: _foundPopularDiets.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) => Container(
                margin:
                    const EdgeInsets.only(bottom: 8), // Beri jarak antar item
                child: FoodCard(
                  food: _foundPopularDiets[index],
                  onAddToCart: (food) => addToCartFirebase(context, food),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Menambahkan item ke cart
  Future<void> addToCartFirebase(
      BuildContext context, PopularDietsModel food) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in first')),
      );
      return;
    }

    String userId = user.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference cartRef = firestore.collection("cart").doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot cartSnapshot = await transaction.get(cartRef);

        List<Map<String, dynamic>> updatedItems = [];
        double totalCost = 0;

        if (cartSnapshot.exists && cartSnapshot.data() != null) {
          Map<String, dynamic> cartData =
              cartSnapshot.data() as Map<String, dynamic>;
          List<dynamic> currentItems = cartData["items"] ?? [];

          updatedItems = List<Map<String, dynamic>>.from(currentItems);

          bool itemExists = false;
          for (var item in updatedItems) {
            if (item["name"] == food.name) {
              item["quantity"] += 1;
              itemExists = true;
              break;
            }
          }

          if (!itemExists) {
            updatedItems.add({
              "name": food.name,
              "iconPath": food.iconPath,
              "level": food.level,
              "duration": food.duration,
              "calorie": food.calorie,
              "cost": food.cost,
              "quantity": 1,
            });
          }
        } else {
          updatedItems = [
            {
              "name": food.name,
              "iconPath": food.iconPath,
              "level": food.level,
              "duration": food.duration,
              "calorie": food.calorie,
              "cost": food.cost,
              "quantity": 1,
            }
          ];
        }

        // Hitung total harga setelah update
        totalCost = updatedItems.fold(
            0, (sum, item) => sum + (item["cost"] * item["quantity"]));

        transaction.set(
            cartRef,
            {
              "items": updatedItems,
              "total": totalCost,
              "lastUpdated": FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      });

      customToast("Added ${food.name} to cart!");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: ${e.toString()}')),
      );
    }
  }

  Column _dietSection() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Recomendation for diet",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: 150,
          width: 300,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  color: diets[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        diets[index].iconPath,
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        diets[index].name,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                      Text(
                        "${diets[index].level}|${diets[index].durations}|${diets[index].calorie}",
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 141, 141, 141)),
                      ),
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: [
                              diets[index].viewSelections
                                  ? Color.fromARGB(255, 161, 151, 500)
                                  : Colors.transparent,
                              diets[index].viewSelections
                                  ? const Color.fromARGB(255, 104, 159, 235)
                                  : Colors.transparent,
                            ])),
                        child: Center(
                            child: Text(
                          "View",
                          style: TextStyle(
                            color: diets[index].viewSelections
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 20),
            itemCount: diets.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
        )
      ],
    );
  }

  Container _searchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          hintText: "Search Here", // Pastikan ini bukan typo
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 186, 186, 186),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset("assets/icons/search.png"),
          ),
          suffixIcon: Container(
            width: 100,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const VerticalDivider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 0.1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/icons/filter.png"),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "MealWell",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: Icon(
              Icons.person,
              size: 30,
              color: tdBlack,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (e) => MySettingPage()));
            },
          ),
        ),
      ],
    );
  }
}

class _categoriesSection extends StatelessWidget {
  const _categoriesSection({
    required this.categories,
  });

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 100,
            color: Colors.transparent,
            child: ListView.separated(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryDetailPage(category: category),
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: category.boxColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(category.iconPath),
                          ),
                        ),
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
