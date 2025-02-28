import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showTopUpDialog(
    BuildContext context, Function(double) onTopUpSuccess) {
  TextEditingController amountController = TextEditingController();

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration:
        const Duration(milliseconds: 300), // Animasi lebih smooth
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: const Color.fromARGB(0, 255, 0, 0),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)), // Rounded edges
              title: Center(
                  child: const Text(
                "Top-Up Balance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Enter amount"),
                  ),
                  const SizedBox(height: 10),
                  const Text("Quick Top-Up",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 15, // Jarak horizontal antar tombol
                    runSpacing:
                        15, // Jarak vertikal antar baris jika wrap melebihi batas lebar
                    alignment:
                        WrapAlignment.center, // Pusatkan tombol dalam Wrap
                    children: [
                      _topUpButton(context, "10.000", 10000, amountController),
                      _topUpButton(context, "50.000", 50000, amountController),
                      _topUpButton(
                          context, "100.000", 100000, amountController),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      await _topUpBalance(amount);
                      onTopUpSuccess(amount);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Top-Up"),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Widget _topUpButton(BuildContext context, String label, double amount,
    TextEditingController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.text = amount.toString();
    },
    child: Text(
      "Rp$label",
      style: TextStyle(color: tdMoney),
    ),
  );
}

Future<void> _topUpBalance(double amount) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'balance': FieldValue.increment(amount),
      });
      customToast("You success to top-up balance: Rp$amount");
    }
  } catch (e) {
    print("Error updating balance: $e");
  }
}
