// lib/view/cart_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: GetBuilder<CartController>(
        builder: (_) {
          final items = controller.cartItems;
          final total = controller.totalPrice;

          return Column(
            children: [
              // Judul halaman
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 40, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Order",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Daftar item keranjang
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("🛒 Your cart is empty"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, index) =>
                            CartItemCard(item: items[index]),
                      ),
              ),

              // Total harga dan tombol Checkout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (items.isNotEmpty) {
                          Get.toNamed('/checkout', arguments: items);
                        } else {
                          Get.snackbar(
                            "Cart is empty",
                            "Please add items before checkout",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Checkout Now',
                        style: TextStyle(color: Colors.white), // ✅ Teks putih
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
