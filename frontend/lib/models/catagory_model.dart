import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });
  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
      name: "Salad",
      iconPath: "assets/salad_cat.png",
      boxColor: const Color.fromARGB(255, 30, 134, 101),
    ));

    categories.add(CategoryModel(
      name: "Dessert",
      iconPath: "assets/dessert_cat.jpg",
      boxColor: const Color.fromARGB(255, 255, 67, 227),
    ));

    categories.add(CategoryModel(
      name: "Sushi",
      iconPath: "assets/sushi_cat.jpeg",
      boxColor: const Color.fromARGB(255, 255, 255, 27),
    ));

    categories.add(CategoryModel(
      name: "Breakfast",
      iconPath: "assets/breakfast_cat.png",
      boxColor: const Color.fromARGB(255, 52, 195, 179),
    ));

    categories.add(CategoryModel(
        name: "Soup",
        iconPath: "assets/question_mark.jpeg",
        boxColor: const Color.fromARGB(255, 26, 205, 184)));
    categories.add(CategoryModel(
        name: "Healthy Bowl",
        iconPath: "assets/question_mark.jpeg",
        boxColor: const Color.fromARGB(255, 26, 205, 62)));

    categories.add(CategoryModel(
        name: "Vegan",
        iconPath: "assets/question_mark.jpeg",
        boxColor: const Color.fromARGB(255, 26, 205, 184)));

    categories.add(CategoryModel(
        name: "Pasta",
        iconPath: "assets/question_mark.jpeg",
        boxColor: const Color.fromARGB(255, 26, 205, 184)));
    categories.add(CategoryModel(
      name: "Protein",
      iconPath: "assets/breakfast_cat.png",
      boxColor: const Color.fromARGB(255, 231, 215, 69),
    ));

    return categories;
  }
}
