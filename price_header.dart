import 'package:flutter/material.dart';

class PriceHeader extends StatelessWidget {
  final double? goldPrice;
  final double? silverPrice;

  PriceHeader({this.goldPrice, this.silverPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _priceCard("Gold (XAU)", goldPrice),
        _priceCard("Silver (XAG)", silverPrice),
      ],
    );
  }

  Widget _priceCard(String label, double? price) {
    String formattedPrice = price != null ? "₹${price.toStringAsFixed(2)}" : "N/A";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(formattedPrice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
