import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/favorite_item_card.dart';
import '../utils/app_textstyles.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("FAVORITE", style: AppTextStyle.h3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: GetBuilder<FavoriteController>(
        builder: (_) {
          final items = controller.favorites;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Your Favorite',
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
                            "❤️ No favorite items yet",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final shoe = items[index];
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
                            child: FavoriteItemCard(shoe: shoe),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}



