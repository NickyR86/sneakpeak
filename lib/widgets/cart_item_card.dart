// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/cart_controller.dart';
// import '../models/cart_item.dart';

// class CartItemCard extends StatelessWidget {
//   final CartItem item;
//   const CartItemCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CartController>();
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Image.asset(item.shoe.image, height: 70, width: 70, fit: BoxFit.contain),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item.shoe.title, style: const TextStyle(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 4),
//                 Text(item.shoe.price, style: TextStyle(color: primaryColor)),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove_circle_outline),
//                 onPressed: () => controller.decreaseQuantity(item),
//               ),
//               Text(item.quantity.toString()),
//               IconButton(
//                 icon: const Icon(Icons.add_circle_outline),
//                 onPressed: () => controller.increaseQuantity(item),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 onPressed: () => controller.removeFromCart(item),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Gambar sepatu
          Image.asset(item.shoe.image, height: 70, width: 70, fit: BoxFit.contain),
          const SizedBox(width: 12),

          // Informasi produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.shoe.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(item.shoe.price, style: TextStyle(color: primaryColor)),
                const SizedBox(height: 4),
                Text("Color: ${item.selectedColor} | Size: ${item.selectedSize}"),
              ],
            ),
          ),

          // Kontrol kuantitas
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => controller.decreaseQuantity(item),
              ),
              Text(item.quantity.toString()),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => controller.increaseQuantity(item),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => controller.removeFromCart(item),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
