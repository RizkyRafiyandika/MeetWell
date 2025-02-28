import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up (Register User)
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "email": email,
          "username": username,
          "balance": 0.0, // Default balance
          "createdAt": FieldValue.serverTimestamp(),
        });

        return user;
      }
      return null;
    } catch (e) {
      throw Exception("Sign-up failed: ${e.toString()}");
    }
  }

  // Sign In (Login User)
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  // Fetch User Balance
  Future<double> getUserBalance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(user.uid).get();
      return (doc["balance"] ?? 0.0).toDouble();
    }
    return 0.0;
  }

  // Update User Balance
  Future<void> updateUserBalance(double amount) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).update({
        "balance": FieldValue.increment(amount),
      });
    }
  }

  // Checkout Function
  Future<String> checkout(double totalCost) async {
    User? user = _auth.currentUser;
    if (user == null) return "User not logged in";

    DocumentSnapshot userSnapshot =
        await _firestore.collection("users").doc(user.uid).get();
    double currentBalance = (userSnapshot["balance"] ?? 0.0).toDouble();

    if (currentBalance >= totalCost) {
      await _firestore.collection("users").doc(user.uid).update({
        "balance": currentBalance - totalCost,
      });
      return "Checkout successful!";
    } else {
      return "Insufficient balance!";
    }
  }
}
