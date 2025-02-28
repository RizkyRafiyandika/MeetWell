import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/cartItem_model.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<CartItem> cartItems = [];
  double userBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      user = userCredential.user;
    }

    if (user != null) {
      await _fetchUserBalance(user.uid);
      await _fetchCartItems(user.uid);
    }
  }

  Future<void> _fetchUserBalance(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      setState(() {
        userBalance = (userSnapshot['balance'] ?? 0).toDouble();
      });
    }
  }

  Future<void> _fetchCartItems(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('cart').doc(userId).get();

      if (!docSnapshot.exists) return;

      List<dynamic> itemsList = docSnapshot['items'] ?? [];

      if (mounted) {
        setState(() {
          cartItems = itemsList.map((item) {
            return CartItem(
              name: item['name'],
              level: item['level'],
              duration: item['duration'],
              calorie: item['calorie'],
              cost: item['cost'],
              quantity: item['quantity'],
              iconPath: item['iconPath'],
            );
          }).toList();
        });
      }
    } catch (e) {
      print("🔥 Error fetching cart items: $e");
    }
  }

  double _calculateTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + (item.cost * item.quantity));
  }

  int _calculateItemTotal() {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _changeQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity =
          (cartItems[index].quantity + change).clamp(0, 100);

      if (cartItems[index].quantity == 0) {
        cartItems.remove(cartItems[index]);
      }
    });

    _updateCart();
  }

  Future<void> _updateCart() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    FirebaseFirestore.instance.collection('cart').doc(userId).update({
      "items": cartItems.map((item) {
        return {
          "name": item.name,
          "level": item.level,
          "duration": item.duration,
          "calorie": item.calorie,
          "cost": item.cost,
          "quantity": item.quantity,
          "iconPath": item.iconPath,
        };
      }).toList(),
    });
  }

  Future<void> _checkout() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    double totalPrice = _calculateTotalPrice();

    if (userId.isEmpty) return;
    if (cartItems.isEmpty) {
      customToast("You need to Order Something!");
      return;
    }
    if (userBalance < totalPrice) {
      customToast("Insufficient balance!");
      return;
    }

    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        transaction.update(userRef, {"balance": userBalance - totalPrice});

        DocumentReference cartRef =
            FirebaseFirestore.instance.collection('cart').doc(userId);
        transaction.update(cartRef, {"items": [], "total": 0});
      });

      setState(() {
        cartItems.clear();
      });

      customToast(
          "✅ Checkout Successful! Rp $totalPrice deducted from your balance.");
    } catch (e) {
      print("Checkout failed: $e");
      customToast("Checkout failed, please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Checkout", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _cartInfoSection(),
            const SizedBox(height: 10),
            _checkoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _cartInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tdcyan.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: const Text("Checkout Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Balance: ${userBalance}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Total Food: ${_calculateItemTotal()}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Total Items: ${cartItems.length}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Food cart"),
            children: [
              cartItems.isEmpty
                  ? _emptyCart()
                  : SizedBox(height: 150, child: _listCart()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyCart() {
    return const Center(
      child: Text(
        'No items in cart',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _checkoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tdcyan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Harga:"),
              Text("Rp ${_calculateTotalPrice()}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkout,
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCart() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: Image.asset(item.iconPath, width: 50, height: 50),
          title: Text(item.name),
          subtitle: Text('${item.level} | ${item.duration} | ${item.calorie}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => _changeQuantity(index, -1)),
              Text('${item.quantity}'),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _changeQuantity(index, 1)),
            ],
          ),
        );
      },
    );
  }
}
