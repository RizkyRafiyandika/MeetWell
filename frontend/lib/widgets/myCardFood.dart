import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/models/popular_model.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final PopularDietsModel food;
  final Function(PopularDietsModel) onAddToCart;

  const FoodCard({Key? key, required this.food, required this.onAddToCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: food.boxIsSelected ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: food.boxIsSelected ? tdbackground : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: food.boxIsSelected
              ? [
                  BoxShadow(
                    color: const Color(0xff1D1617).withOpacity(0.07),
                    offset: const Offset(0, 10),
                    blurRadius: 40,
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset(food.iconPath, width: 65, height: 65),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${food.level} | ${food.duration} | ${food.calorie}',
                    style: const TextStyle(
                      color: Color(0xff7B6F72),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Harga: Rp ${food.cost}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onAddToCart(food),
              icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
