import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/shoe_model.dart';
import '../view/product_detail.dart';

class ShoeCard extends StatelessWidget {
  final ShoeModel shoe;

  const ShoeCard({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final favoriteController = Get.find<FavoriteController>();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailPage(shoe: shoe)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      shoe.image,
                      fit: BoxFit.contain,
                      height: 130,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GetBuilder<FavoriteController>(
                    builder: (_) {
                      final isFavorite = favoriteController.isFavorite(shoe);
                      return GestureDetector(
                        onTap: () => favoriteController.toggleFavorite(shoe),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? primaryColor : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        double rating = shoe.rating;
                        IconData icon;
                        if (rating >= index + 1) {
                          icon = Icons.star;
                        } else if (rating > index && rating < index + 1) {
                          icon = Icons.star_half;
                        } else {
                          icon = Icons.star_border;
                        }
                        return Icon(icon, size: 14, color: Colors.amber);
                      }),
                      const SizedBox(width: 4),
                      Text(
                        shoe.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shoe.price,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



