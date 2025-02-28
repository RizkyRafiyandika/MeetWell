import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/models/popular_model.dart';
import 'package:fitness2/services/diet_service.dart';
import 'package:fitness2/widgets/myCardFood.dart';
import 'package:flutter/material.dart';
import 'package:fitness2/models/catagory_model.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Future<List<PopularDietsModel>> popularDietsFuture;

  @override
  void initState() {
    super.initState();
    popularDietsFuture =
        DietService().fetchPopularDiets(); // Ambil data makanan dari API
  }

  // Fungsi untuk mendapatkan warna acak
  Color _getRandomColor({double opacity = 1.0}) {
    Random random = Random();
    return Color.fromRGBO(
      100 + random.nextInt(156), // Hindari warna terlalu gelap
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      opacity, // Opacity bisa diatur
    );
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor =
        _getRandomColor(); // Warna acak untuk AppBar dan Container

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: randomColor.withOpacity(0.8),
      ),
      body: FutureBuilder<List<PopularDietsModel>>(
        future: popularDietsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Error jika terjadi kesalahan
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available')); // Tidak ada data
          } else {
            // Filter makanan berdasarkan kategori
            List<PopularDietsModel> filteredFoods = snapshot.data!
                .where((food) => food.type == widget.category.name)
                .toList();

            return ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];

                return FoodCard(
                  food: food,
                  onAddToCart: (selectedFood) {
                    addToCartFirebase(context, selectedFood);
                    final snackBar = SnackBar(
                      content:
                          Text('Yay! Order Complete\n${selectedFood.name}'),
                      duration: const Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${food.name} to cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: ${e.toString()}')),
      );
    }
  }
}
