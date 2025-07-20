import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../services/cart_storage.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  List<CartItem> get cartItems => _cartItems;

  late String userEmail;

  void setUserEmail(String email) {
    userEmail = email;
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await CartStorage.loadCartForUser(userEmail);
    _cartItems.assignAll(items);
  }

  void saveCart() => CartStorage.saveCartForUser(userEmail, _cartItems.toList());

  double get totalPrice => _cartItems.fold(0.0, (sum, item) {
    // Hilangkan simbol $, tapi biarkan titik desimal
    final cleanedPrice = item.shoe.price
        .replaceAll('\$', '')         // Hapus tanda dolar
        .replaceAll('Rp ', '')        // Hapus "Rp " jika ada
        .replaceAll(',', '');         // Hapus koma ribuan jika ada, contoh 1,000.00

    final price = double.tryParse(cleanedPrice) ?? 0.0;
    return sum + (price * item.quantity);
  });

  void addToCart(CartItem item) {
    final index = _cartItems.indexWhere((e) =>
      e.shoe.title == item.shoe.title &&
      e.selectedColor == item.selectedColor &&
      e.selectedSize == item.selectedSize
    );

    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    saveCart();
    update();
  }

  void increaseQuantity(CartItem item) {
    final index = _cartItems.indexWhere((e) =>
      e.shoe.title == item.shoe.title &&
      e.selectedColor == item.selectedColor &&
      e.selectedSize == item.selectedSize
    );

    if (index != -1) {
      _cartItems[index].quantity++;
      saveCart();
      update();
    }
  }

  void decreaseQuantity(CartItem item) {
    final index = _cartItems.indexWhere((e) =>
      e.shoe.title == item.shoe.title &&
      e.selectedColor == item.selectedColor &&
      e.selectedSize == item.selectedSize
    );

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      saveCart();
      update();
    }
  }

  void removeFromCart(CartItem item) {
    _cartItems.removeWhere((e) =>
      e.shoe.title == item.shoe.title &&
      e.selectedColor == item.selectedColor &&
      e.selectedSize == item.selectedSize
    );
    saveCart();
    update();
  }

  void clearCart() {
    _cartItems.clear();
    saveCart();
    update();
  }
}


