class PopularDietsModel {
  String name;
  String type;
  String iconPath;
  String level;
  String duration;
  String calorie;
  bool boxIsSelected;
  int cost;

  PopularDietsModel(
      {required this.name,
      required this.type,
      required this.iconPath,
      required this.level,
      required this.duration,
      required this.calorie,
      required this.boxIsSelected,
      required this.cost});

  factory PopularDietsModel.fromJson(Map<String, dynamic> json) {
    return PopularDietsModel(
      name: json['name'],
      type: json["type"],
      iconPath: json['iconPath'],
      level: json['level'],
      duration: json['duration'],
      calorie: json['calorie'],
      boxIsSelected: json['boxIsSelected'],
      cost: json['cost'],
    );
  }

  // static List<PopularDietsModel> getPopularDiets() {
  //   List<PopularDietsModel> popularDiets = [];

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Blueberry Pancake',
  //     iconPath: 'assets/blueberry_pancake.jpeg',
  //     level: 'Medium',
  //     duration: '30mins',
  //     calorie: '230kCal',
  //     boxIsSelected: true,
  //   ));

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Salmon Nigiri',
  //     iconPath: 'assets/salmon_nigiri.jpeg',
  //     level: 'Easy',
  //     duration: '20mins',
  //     calorie: '120kCal',
  //     boxIsSelected: true,
  //   ));

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Salmon Nigiri',
  //     iconPath: 'assets/salmon_nigiri.jpeg',
  //     level: 'Easy',
  //     duration: '20mins',
  //     calorie: '120kCal',
  //     boxIsSelected: true,
  //   ));

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Avocado Toast',
  //     iconPath: 'assets/blueberry_pancake.jpeg', // Same image as pancake
  //     level: 'Easy',
  //     duration: '10mins',
  //     calorie: '150kCal',
  //     boxIsSelected: true,
  //   ));

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Greek Yogurt Parfait',
  //     iconPath: 'assets/blueberry_pancake.jpeg', // Same image as pancake
  //     level: 'Easy',
  //     duration: '5mins',
  //     calorie: '100kCal',
  //     boxIsSelected: true,
  //   ));

  //   popularDiets.add(PopularDietsModel(
  //     name: 'Quinoa Salad',
  //     iconPath: 'assets/blueberry_pancake.jpeg', // Same image as pancake
  //     level: 'Medium',
  //     duration: '25mins',
  //     calorie: '200kCal',
  //     boxIsSelected: true,
  //   ));

  //   return popularDiets;
  // }
}
