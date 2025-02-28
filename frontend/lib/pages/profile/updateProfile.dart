import 'package:fitness2/models/customeTextField.dart';
import 'package:flutter/material.dart';
import 'package:fitness2/constants/colors.dart';

class MyUpdateProfile extends StatefulWidget {
  const MyUpdateProfile({super.key});

  @override
  State<MyUpdateProfile> createState() => _MyUpdateProfileState();
}

class _MyUpdateProfileState extends State<MyUpdateProfile> {
  // final _formKey = GlobalKey<FormState>();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Field
              CustomTextField(
                // controller: _emailController,
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
              const SizedBox(height: 16),

              // Username Field
              CustomTextField(
                // controller: _usernameController,
                label: "Username",
                hintText: "Enter Your Username",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username Can't be Empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              CustomTextField(
                // controller: _passwordController,
                label: "Password",
                hintText: "Enter Your Password",
                obscureText: true, // Untuk menyembunyikan password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password Can't be Empty";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   // Lakukan proses update data
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("Profile Updated")),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdblue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
