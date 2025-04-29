import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import '../services/gold_api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? priceData;
  bool isLoading = true;
  bool isRefreshing = false; // For animated refresh icon

  @override
  void initState() {
    super.initState();
    fetchPrices();
  }

  Future<void> fetchPrices() async {
    setState(() {
      isLoading = true;
      isRefreshing = true;
    });

    try {
      var data = await GoldAPI.fetchPrices();
      setState(() {
        priceData = data;
        isLoading = false;
      });

      // Stop refresh animation after a delay
      Timer(Duration(seconds: 1), () {
        setState(() => isRefreshing = false);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠ Failed to fetch prices. Please try again.'),
          backgroundColor: Colors.redAccent.shade200,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF8F5), // Neutral background
      appBar: AppBar(
        title: Text(
          'Gold & Silver Prices',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.brown[400]))
          : priceData == null
          ? Center(
        child: Text(
          '⚠ Failed to load data',
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchPrices,
        color: Colors.brown[400],
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gold & Silver Cards (Animated FadeIn)
              FadeIn(
                duration: Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildLivePriceCard("🪙 Gold (XAU)", priceData!['gold']['XAU'], Color(0xFFD4AF37)),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildLivePriceCard("⬜ Silver (XAG)", priceData!['silver']['XAG'], Color(0xFFC0C0C0)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Gold & Silver Price Details (Slide-in Animation)
              SlideInUp(
                duration: Duration(milliseconds: 500),
                child: _buildPriceDetailsSection("🪙 Gold Price Details", priceData!['gold'], Color(0xFFD4AF37)),
              ),
              SizedBox(height: 12),
              SlideInUp(
                duration: Duration(milliseconds: 600),
                child: _buildPriceDetailsSection("⬜ Silver Price Details", priceData!['silver'], Color(0xFFC0C0C0)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchPrices,
        backgroundColor: Colors.brown[400],
        child: AnimatedRotation(
          duration: Duration(milliseconds: 400),
          turns: isRefreshing ? 1 : 0,
          child: Icon(Icons.refresh, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLivePriceCard(String title, double price, Color color) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.6), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              "₹ ${price.toStringAsFixed(2)}",
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "📍 Just Updated",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailsSection(String title, Map<String, dynamic> data, Color color) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5), width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Divider(color: color.withOpacity(0.7), thickness: 1),
            _buildPriceRow("1 Gram", data['1g'], color),
            _buildPriceRow("10 Gram", data['10g'], color),
            _buildPriceRow("100 Gram", data['100g'], color),
            _buildPriceRow("1 KG", data['1kg'], color),
            _buildPriceRow("1 Tola (11.66g)", data['1g'] * 11.66, color),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double price, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.black87, fontSize: 16)),
          Text(
            "₹ ${price.toStringAsFixed(2)}",
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
