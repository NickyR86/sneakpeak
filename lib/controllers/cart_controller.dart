import 'package:get/get.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice => _cartItems.fold(0, (sum, item) {
    final price = double.tryParse(item.shoe.price.replaceAll('\$', '')) ?? 0.0;
    return sum + (price * item.quantity);
  });

  void addToCart(CartItem item) {
    final index = _cartItems.indexWhere((e) => e.shoe.title == item.shoe.title);
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    update();
  }

  void increaseQuantity(CartItem item) {
    final index = _cartItems.indexWhere((e) => e.shoe.title == item.shoe.title);
    if (index != -1) {
      _cartItems[index].quantity++;
      update();
    }
  }

  void decreaseQuantity(CartItem item) {
    final index = _cartItems.indexWhere((e) => e.shoe.title == item.shoe.title);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      update();
    }
  }

  void removeFromCart(CartItem item) {
    _cartItems.removeWhere((e) => e.shoe.title == item.shoe.title);
    update();
  }
}
