import 'package:flutter/material.dart';

class CustomeLogin extends StatelessWidget {
  const CustomeLogin({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/image_bg.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
