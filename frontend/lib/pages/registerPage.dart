import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/CustomeLogin_scaffold.dart';
import 'package:fitness2/models/customeSocialAuth.dart';
import 'package:fitness2/models/customeTextField.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:fitness2/pages/loginPage.dart';
import 'package:fitness2/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key});

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final _formRegisterKey = GlobalKey<FormState>();

  final FirebaseAuthService _auth =
      FirebaseAuthService(); // ✅ Singleton Instance

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomeLogin(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 20)),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: tdcyan.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formRegisterKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Register Here",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: tdbackground),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _usernameController,
                          label: "UserName",
                          hintText: "Please Fill Username",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username Can't be Empty";
                            } else if (value.length > 8) {
                              return "Username Must be 8 Characters or Less";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          label: "Email",
                          hintText: "Please Fill Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email Can't be Empty";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                              return "Invalid Email Format";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Password",
                          hintText: "Please Fill The Password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password Can't be Empty";
                            } else if (value.length < 6) {
                              return "Password Must be at Least 6 Characters";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: tdblue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: _Register,
                            // ✅ Dipanggil dengan benar
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: tdbackground,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                                thickness: 1,
                                indent: 20,
                                endIndent: 10,
                              ),
                            ),
                            const Text(
                              "Or sign in with",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                                thickness: 1,
                                indent: 20,
                                endIndent: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialAuthButton(
                              assetPath: "assets/icons/google.png",
                              lbl: "Google",
                            ),
                            const SizedBox(width: 20),
                            SocialAuthButton(
                              assetPath: "assets/icons/facebook.png",
                              lbl: "Facebook",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _Register() async {
    if (!_formRegisterKey.currentState!.validate()) return;

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user =
          await _auth.signUpWithEmailAndPassword(email, password, username);

      if (user != null) {
        // ✅ Tampilkan toast saat berhasil registrasi
        customToast("Yey! You registered successfully");

        print("User successfully registered and data saved to Firestore");

        // Navigasi ke halaman login hanya setelah sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyLoginPage()),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString()); // Menampilkan error ke user
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
