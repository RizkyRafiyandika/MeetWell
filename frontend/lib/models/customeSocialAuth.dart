import 'package:fitness2/constants/colors.dart';
import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String assetPath;
  final String lbl;
  final VoidCallback onPressed;

  const SocialAuthButton({
    Key? key,
    required this.assetPath,
    required this.lbl,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tdbackground,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(assetPath, width: 30, height: 30),
            const SizedBox(
              width: 10,
            ),
            Text(lbl,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500, color: tdBlack))
          ],
        ),
      ),
    );
  }
}
