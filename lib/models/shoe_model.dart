class ShoeModel {
  final String image;
  final String title;
  final String price;
  final String description;
  final String brand;
  final double rating;
  final List<int> sizes;
  final List<String> colors;

  const ShoeModel({
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.brand,
    required this.rating,
    required this.sizes,
    required this.colors,
  });

  factory ShoeModel.fromJson(Map<String, dynamic> json) {
    return ShoeModel(
      image: json['image'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      brand: json['brand'],
      rating: (json['rating'] as num).toDouble(),
      sizes: List<int>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'price': price,
      'description': description,
      'brand': brand,
      'rating': rating,
      'sizes': sizes,
      'colors': colors,
    };
  }
}

