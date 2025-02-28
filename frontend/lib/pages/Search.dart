import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:fitness2/models/popular_model.dart';
import 'package:fitness2/services/diet_service.dart';
import 'package:fitness2/widgets/myCardFood.dart';
import 'package:flutter/material.dart';

class MySearch extends StatefulWidget {
  const MySearch({super.key});

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  final TextEditingController _searchController = TextEditingController();
  List<PopularDietsModel> _popularDiets = [];
  List<PopularDietsModel> _filteredDiets = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularDiets();
  }

  Future<void> _fetchPopularDiets() async {
    try {
      _popularDiets = await DietService().fetchPopularDiets();
      setState(() {
        _filteredDiets = List.from(_popularDiets);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      _filteredDiets = query.isEmpty
          ? List.from(_popularDiets)
          : _popularDiets
              .where((diet) =>
                  diet.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredDiets.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6), fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredDiets.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        final food = _filteredDiets[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: FoodCard(
                            food: food,
                            onAddToCart: (food) =>
                                _addToCartFirebase(context, food),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCartFirebase(
      BuildContext context, PopularDietsModel food) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please sign in first')));
      return;
    }

    String userId = user.uid;
    DocumentReference cartRef =
        FirebaseFirestore.instance.collection("cart").doc(userId);

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
          SnackBar(content: Text('Failed to add item: ${e.toString()}')));
    }
  }
}
