import 'package:flutter/material.dart';
import 'package:gold_silver_prices/screen/home_screen.dart';

void main() {
  runApp(GoldSilverApp());
}

class GoldSilverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold & Silver Prices',
      home: HomeScreen(),
    );
  }
}
