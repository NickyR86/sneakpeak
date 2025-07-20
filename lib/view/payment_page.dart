import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_textstyles.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedMethod = 0;

  final List<String> paymentMethods = [
    'Credit / Debit / ATM Card',
    'Paypal Payment',
    'Paytm',
    'Net Banking',
    'Cash On Delivery',
    'EMI ( Easy Installments )',
  ];

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final totalPrice = args['totalPrice'] as double;
    final deliveryFee = args['deliveryFee'] as double;
    final totalPayable = args['totalPayable'] as double;
    final itemCount = args['itemCount'] as int;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("PAYMENTS", style: AppTextStyle.h3),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PAYMENT METHOD
            Container(
              width: double.infinity,
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
                  Text("PAYMENT METHOD",
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 8),
                  ...List.generate(paymentMethods.length, (index) {
                    return RadioListTile(
                      value: index,
                      groupValue: selectedMethod,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        paymentMethods[index],
                        style: AppTextStyle.bodyMedium,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // PRICE DETAILS
            Container(
              width: double.infinity,
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
                  _priceRow(
                    "Price ($itemCount item${itemCount > 1 ? 's' : ''})",
                    totalPrice,
                  ),
                  _priceRow("Delivery Charge", deliveryFee),
                  const Divider(),
                  _priceRow("Amount Payable", totalPayable, isBold: true),
                ],
              ),
            ),

            const Spacer(),

            // CONTINUE TO PAYMENT Button (➡️ go to /success)
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/success');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "CONTINUE TO PAYMENT",
                style: AppTextStyle.buttonMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
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
