import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final String metal;
  final double price;
  final Color color;

  PriceCard({required this.metal, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(metal, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("₹ ${price.toStringAsFixed(2)} per XAU/XAG", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// Price Table Widget
class MetalPriceTable extends StatelessWidget {
  final String metal;
  final Map<String, double> prices;

  MetalPriceTable({required this.metal, required this.prices});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text("$metal Prices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Divider(),
          for (var entry in prices.entries)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 16)),
                  Text("₹ ${entry.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
