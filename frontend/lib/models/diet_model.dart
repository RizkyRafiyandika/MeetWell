import 'package:flutter/material.dart';

class DietModel {
  String name;
  String iconPath;
  String level;
  String durations;
  String calorie;
  Color boxColor;
  bool viewSelections;

  DietModel(
      {required this.name,
      required this.iconPath,
      required this.level,
      required this.durations,
      required this.calorie,
      required this.boxColor,
      required this.viewSelections});

  static List<DietModel> getDiet() {
    List<DietModel> diets = [];

    diets.add(DietModel(
      name: "Honey Pancake",
      iconPath: "assets/salad_cat.png",
      level: "easy",
      durations: "30Mins",
      calorie: "180Kg",
      boxColor: const Color.fromARGB(255, 20, 80, 140),
      viewSelections: true,
    ));

    diets.add(DietModel(
      name: "Honey Pancake",
      iconPath: "assets/salad_cat.png",
      level: "easy",
      durations: "30Mins",
      calorie: "180Kg",
      boxColor: const Color.fromARGB(255, 168, 212, 255),
      viewSelections: true,
    ));
    return diets;
  }
}
