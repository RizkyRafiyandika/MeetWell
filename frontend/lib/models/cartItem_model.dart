class CartItem {
  final String name;
  final String iconPath;
  final String level;
  final String duration;
  final String calorie;
  final int cost;
  int quantity;

  CartItem(
      {required this.name,
      required this.iconPath,
      required this.level,
      required this.duration,
      required this.calorie,
      required this.cost,
      required this.quantity});
}
