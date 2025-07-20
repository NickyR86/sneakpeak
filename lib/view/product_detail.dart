import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';
import '../models/shoe_model.dart';
import '../utils/color_mapper.dart';
import '../utils/app_textstyles.dart';

class ProductDetailPage extends StatefulWidget {
  final ShoeModel shoe;

  const ProductDetailPage({super.key, required this.shoe});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with TickerProviderStateMixin {
  int selectedSizeIndex = 0;
  int selectedColorIndex = 0;

  void _showAnimatedSnackbar(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      animationController.reverse().then((_) {
        overlayEntry.remove();
        animationController.dispose();
      });
    });
  }

  Widget _animatedItem({required Widget child, required int index}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 100),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
      } else if (rating >= i - 0.5) {
        stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
      } else {
        stars.add(const Icon(Icons.star_border, size: 16, color: Colors.amber));
      }
    }

    stars.add(const SizedBox(width: 4));
    stars.add(Text(rating.toStringAsFixed(1)));

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final shoe = widget.shoe;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final shoeColors = shoe.colors.map((c) => ColorMapper.fromName(c)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("PRODUCT DETAIL", style: AppTextStyle.h3),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animatedItem(
                index: 0,
                child: Image.asset(shoe.image, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 24),
              _animatedItem(
                index: 1,
                child: Text(shoe.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              _animatedItem(
                index: 2,
                child: _buildRatingStars(shoe.rating),
              ),
              const SizedBox(height: 12),
              _animatedItem(
                index: 3,
                child: Text(
                  shoe.description ?? "No description available.",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 24),
              _animatedItem(
                index: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select a color", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "\$${shoe.price.replaceAll('\$', '')}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _animatedItem(
                index: 5,
                child: Row(
                  children: List.generate(shoeColors.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedColorIndex = index),
                        child: _AnimatedColorDot(
                          color: shoeColors[index],
                          isSelected: selectedColorIndex == index,
                          primaryColor: primaryColor,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              _animatedItem(
                index: 6,
                child: const Text("Select a size", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              _animatedItem(
                index: 7,
                child: Wrap(
                  spacing: 8,
                  children: List.generate(shoe.sizes.length, (index) {
                    int size = shoe.sizes[index];
                    bool isSelected = selectedSizeIndex == index;
                    return ChoiceChip(
                      label: Text(
                        size.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: primaryColor,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (_) => setState(() => selectedSizeIndex = index),
                      showCheckmark: true,
                      checkmarkColor: Colors.white,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            final cartController = Get.find<CartController>();
            cartController.addToCart(CartItem(
              shoe: shoe,
              selectedColor: shoe.colors[selectedColorIndex],
              selectedSize: shoe.sizes[selectedSizeIndex],
            ));
            _showAnimatedSnackbar("Added to Cart", primaryColor);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "ADD TO CART",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


class _AnimatedColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Color primaryColor;

  const _AnimatedColorDot({
    required this.color,
    required this.isSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? primaryColor : Colors.transparent,
          width: isSelected ? 2.5 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black12,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
