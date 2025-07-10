// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../data/shoe_data.dart';
// import '../utils/color_mapper.dart';
// import '../controllers/cart_controller.dart';
// import '../models/cart_item.dart';

// class ProductDetailPage extends StatefulWidget {
//   final ShoeModel shoe;

//   const ProductDetailPage({super.key, required this.shoe});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> with TickerProviderStateMixin {
//   int selectedSizeIndex = 0;
//   int selectedColorIndex = 0;

//   void _showAnimatedSnackbar(String message, Color backgroundColor) {
//     final overlay = Overlay.of(context);
//     final animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     final curvedAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeOutCubic,
//     );

//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).padding.top + 12,
//         left: 20,
//         right: 20,
//         child: SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0, -0.2),
//             end: Offset.zero,
//           ).animate(curvedAnimation),
//           child: FadeTransition(
//             opacity: curvedAnimation,
//             child: Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: backgroundColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   message,
//                   style: const TextStyle(color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay.insert(overlayEntry);
//     animationController.forward();

//     Future.delayed(const Duration(seconds: 2), () {
//       animationController.reverse().then((_) {
//         overlayEntry.remove();
//         animationController.dispose();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shoe = widget.shoe;
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     final shoeColors = shoe.colors.map((c) => ColorMapper.fromName(c)).toList();
//     final cartController = Get.find<CartController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text("Product Detail", style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gambar
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Image.asset(shoe.image, fit: BoxFit.contain),
//             ),
//             const SizedBox(height: 16),

//             // Judul dan harga
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     shoe.title,
//                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Text(
//                   shoe.price,
//                   style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Rating
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade700,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.white, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         shoe.rating.toStringAsFixed(1),
//                         style: const TextStyle(color: Colors.white, fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Deskripsi
//             Text(
//               shoe.description ?? "No description available.",
//               style: const TextStyle(color: Colors.black54),
//             ),
//             const SizedBox(height: 16),

//             // Size
//             const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               children: List.generate(shoe.sizes.length, (index) {
//                 int size = shoe.sizes[index];
//                 bool isSelected = selectedSizeIndex == index;
//                 return ChoiceChip(
//                   label: Text(
//                     size.toString(),
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   selected: isSelected,
//                   selectedColor: primaryColor,
//                   backgroundColor: Colors.grey.shade200,
//                   onSelected: (_) => setState(() => selectedSizeIndex = index),
//                   showCheckmark: true,
//                   checkmarkColor: Colors.white,
//                 );
//               }),
//             ),
//             const SizedBox(height: 16),

//             // Colors
//             const Text("Colors", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Row(
//               children: List.generate(shoeColors.length, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: GestureDetector(
//                     onTap: () => setState(() => selectedColorIndex = index),
//                     child: _AnimatedColorDot(
//                       color: shoeColors[index],
//                       isSelected: selectedColorIndex == index,
//                       primaryColor: primaryColor,
//                     ),
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Tombol aksi
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       cartController.addToCart(CartItem(shoe: shoe));
//                       _showAnimatedSnackbar("Added to Cart", primaryColor);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: BorderSide(color: primaryColor, width: 2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text("ADD TO CART", style: TextStyle(color: primaryColor)),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => _showAnimatedSnackbar("Proceeding to Buy Now...", primaryColor),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text("BUY NOW", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AnimatedColorDot extends StatelessWidget {
//   final Color color;
//   final bool isSelected;
//   final Color primaryColor;

//   const _AnimatedColorDot({
//     required this.color,
//     required this.isSelected,
//     required this.primaryColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 36,
//       height: 36,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isSelected ? primaryColor : Colors.transparent,
//           width: isSelected ? 3 : 0,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         width: 22,
//         height: 22,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/shoe_data.dart';
import '../utils/color_mapper.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';

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

  @override
  Widget build(BuildContext context) {
    final shoe = widget.shoe;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final shoeColors = shoe.colors.map((c) => ColorMapper.fromName(c)).toList();
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Product Detail", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(shoe.image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),

            // Judul dan harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    shoe.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  shoe.price,
                  style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        shoe.rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Deskripsi
            Text(
              shoe.description ?? "No description available.",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Size
            const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
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
            const SizedBox(height: 16),

            // Colors
            const Text("Colors", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(shoeColors.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
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
            const SizedBox(height: 24),

            // Tombol aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      cartController.addToCart(
                        CartItem(
                          shoe: shoe,
                          selectedColor: shoe.colors[selectedColorIndex],
                          selectedSize: shoe.sizes[selectedSizeIndex],
                        ),
                      );
                      _showAnimatedSnackbar("Added to Cart", primaryColor);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("ADD TO CART", style: TextStyle(color: primaryColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showAnimatedSnackbar("Proceeding to Buy Now...", primaryColor),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("BUY NOW", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
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
          width: isSelected ? 3 : 0,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
