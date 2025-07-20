import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item_card.dart';
import '../utils/app_textstyles.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showErrorDialog(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "CartErrorDialog",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cart is Empty", style: AppTextStyle.h3.copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text("Please add items before proceeding to checkout.", style: AppTextStyle.bodySmall.copyWith(color: Colors.black87)),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("OK", style: AppTextStyle.buttonLarge.copyWith(color: primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, _, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text("CART", style: AppTextStyle.h3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: GetBuilder<CartController>(
        builder: (_) {
          final items = controller.cartItems;
          final total = controller.totalPrice;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Your Cart',
                    style: AppTextStyle.h3,
                  ),
                ),
              Expanded(
                child: items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 310),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "🛒 Your cart is empty",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 400 + index * 100),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: CartItemCard(item: item),
                          );
                        },
                      ),
              ),
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
                          _showErrorDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Checkout Now',
                        style: TextStyle(color: Colors.white),
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


