import 'shoe_model.dart';

class CartItem {
  final ShoeModel shoe;
  final String selectedColor;
  final int selectedSize;
  int quantity;

  CartItem({
    required this.shoe,
    required this.selectedColor,
    required this.selectedSize,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shoe: ShoeModel.fromJson(json['shoe']),
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shoe': shoe.toJson(),
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }
}
