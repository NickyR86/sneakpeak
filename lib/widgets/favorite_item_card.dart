import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/shoe_model.dart';
import '../controllers/favorite_controller.dart';

class FavoriteItemCard extends StatelessWidget {
  final ShoeModel shoe;
  const FavoriteItemCard({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
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
          Image.asset(shoe.image, height: 70, width: 70, fit: BoxFit.contain),
          const SizedBox(width: 12),

          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shoe.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(shoe.price, style: TextStyle(color: primaryColor)),
              ],
            ),
          ),

          // Tombol favorite
          IconButton(
            icon: Icon(Icons.favorite, color: primaryColor),
            onPressed: () => controller.toggleFavorite(shoe),
          ),
        ],
      ),
    );
  }
}
