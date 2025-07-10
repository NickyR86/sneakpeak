// File: shoe_model.dart
class ShoeModel {
  final String image;
  final String title;
  final String price;
  final String? description;
  final String brand;
  final double rating;
  final List<int> sizes;
  final List<String> colors;

  const ShoeModel({
    required this.image,
    required this.title,
    required this.price,
    this.description,
    required this.brand,
    required this.rating,
    required this.sizes,
    required this.colors,
  });
}
