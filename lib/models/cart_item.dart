// import '../data/shoe_data.dart';

// class CartItem {
//   final ShoeModel shoe;
//   int quantity;

//   CartItem({required this.shoe, this.quantity = 1});
// }

import '../data/shoe_data.dart';

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
}
