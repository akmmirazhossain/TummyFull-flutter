// meal_model.dart

class Meal {
  final String name;
  final String description;
  final String imageUrl;
  final String startTime;
  final String endTime;
  final double price;

  Meal({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      price: json['price'].toDouble(),
    );
  }
}
