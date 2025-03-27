import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/CustomeLogin_scaffold.dart';
import 'package:fitness2/pages/loginPage.dart';
import 'package:fitness2/pages/registerPage.dart';
import 'package:fitness2/widgets/myNavigationMenu.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomeLogin(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome To \n WellMeal",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Your Meal Always Serve Here!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 62, 60, 60),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (e) => MyLoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            // Register Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (e) => MyRegisterPage()));
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInAnonymously();
                  print("Login as guest: ${userCredential.user?.uid}");

                  // Navigasi ke halaman home setelah login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyNavigationMenu()),
                  );
                } catch (e) {
                  print("Error login as guest: $e");
                }
              },
              child: Text(
                "As Guest",
                style: TextStyle(color: tdcyan, fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
