import 'package:firebase_core/firebase_core.dart';
import 'package:fitness2/firebase_options.dart';
import 'package:fitness2/widgets/myNavigationMenu.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Tambahkan ini sebelum Firebase.initializeApp()
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp()); // Jalankan aplikasi setelah Firebase siap
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TODO APPS",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins", // Pastikan font sudah terdaftar di pubspec.yaml
        primarySwatch: Colors.blue, // Tambahkan default warna
      ),
      home: MyNavigationMenu(),
    );
  }
}
