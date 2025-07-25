import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/user_model.dart';
import '../services/user_storage.dart';
import '../utils/color_mapper.dart';
import '../utils/app_textstyles.dart';
import 'address_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<UserModel?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = UserStorage.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> checkoutItems = (Get.arguments as List).cast<CartItem>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    final totalPrice = checkoutItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.shoe.price.replaceAll('\$', '')) ?? 0.0;
      return sum + (price * item.quantity);
    });

    final totalQuantity = checkoutItems.fold(0, (sum, item) => sum + item.quantity);
    const deliveryFee = 5.0;
    final totalPayable = totalPrice + deliveryFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ORDER SUMMARY", style: AppTextStyle.h3),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Shopping Address Box
          FutureBuilder<UserModel?>(
            future: _futureUser,
            builder: (context, snapshot) {
              final user = snapshot.data;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SHOPPING ADDRESS", style: AppTextStyle.bodySmall.copyWith(color: Colors.grey[700],
                        fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(user?.displayName ?? '-', style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(user?.phone ?? '-', style: AppTextStyle.bodySmall.copyWith(color: const Color.fromARGB(255, 0, 0, 0))),
                      const SizedBox(height: 4),
                      Text(user?.address ?? 'No address available', style: AppTextStyle.bodyMedium),
                    ],
                  ),
                ),
              );
            },
          ),

          FutureBuilder<UserModel?>(
            future: _futureUser,
            builder: (context, snapshot) {
              final user = snapshot.data;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (user != null) {
                      final result = await Get.to(() => AddressPage(user: user));
                      if (result == true) {
                        setState(() {
                          _futureUser = UserStorage.getLoggedInUser();
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: Text(
                    "CHANGE OR ADD ADDRESS",
                    style: AppTextStyle.buttonMedium.copyWith(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // Product List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: checkoutItems.length,
              itemBuilder: (_, index) {
                final item = checkoutItems[index];
                final shoe = item.shoe;
                final price = double.tryParse(shoe.price.replaceAll('\$', '')) ?? 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          shoe.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain, // Gambar tidak terpotong
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shoe.title, style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text("Size: ${item.selectedSize}", style: AppTextStyle.bodyMedium),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("Color: ", style: AppTextStyle.bodyMedium),
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: ColorMapper.fromName(item.selectedColor),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                ),
                                Text(item.selectedColor, style: AppTextStyle.bodyMedium),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "\$${(price * item.quantity).toStringAsFixed(2)}",
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("x${item.quantity}", style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Price Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PRICE DETAILS",
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 8),
                  _priceRow("Price ($totalQuantity item${totalQuantity > 1 ? 's' : ''})", totalPrice),
                  _priceRow("Delivery Charge", deliveryFee),
                  const Divider(thickness: 1),
                  _priceRow("Amount Payable", totalPayable, isBold: true),
                ],
              ),
            ),
          ),

          // Continue to Payment Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/payment', arguments: {
                  'items': checkoutItems,
                  'totalPrice': totalPrice,
                  'deliveryFee': deliveryFee,
                  'totalPayable': totalPayable,
                  'itemCount': totalQuantity,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "CONTINUE TO PAYMENT",
                style: AppTextStyle.buttonMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isBold = false}) {
    final style = isBold
        ? AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold)
        : AppTextStyle.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text("\$${value.toStringAsFixed(2)}", style: style),
        ],
      ),
    );
  }
}

