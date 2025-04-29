import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatefulWidget {
  final List<double> prices;
  final Color color;
  final String title;
  final List<String> timePeriods;

  PriceChart({required this.prices, required this.color, required this.title, required this.timePeriods});

  @override
  _PriceChartState createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  String selectedTimePeriod = "1M"; // Default selection: 1 Month

  // Dummy past price data (replace this with API historical data)
  final Map<String, List<double>> pastPrices = {
    "1M": List.generate(30, (index) => 50000 + index * 20.0), // 1 Month data
    "6M": List.generate(30, (index) => 48000 + index * 100.0), // 6 Months data
    "1Y": List.generate(30, (index) => 47000 + index * 150.0), // 1 Year data
    "5Y": List.generate(30, (index) => 40000 + index * 250.0), // 5 Years data
  };

  @override
  Widget build(BuildContext context) {
    List<double> selectedPrices = pastPrices[selectedTimePeriod] ?? widget.prices;
    double minPrice = selectedPrices.reduce((a, b) => a < b ? a : b);
    double maxPrice = selectedPrices.reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Time Period Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                //DROP DOWN BUTTON
                DropdownButton<String>(
                  value: selectedTimePeriod,
                  items: widget.timePeriods.map((String period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(period, style: TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTimePeriod = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Price Graph
            AspectRatio(
              aspectRatio: 1.8,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxPrice - minPrice) / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: (maxPrice - minPrice) / 4,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${value.toInt()}',
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: (selectedPrices.length / 5).clamp(1, 5).toDouble(),
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= selectedPrices.length) return SizedBox.shrink();
                          return Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  minX: 0,
                  maxX: (selectedPrices.length - 1).toDouble(),
                  minY: minPrice * 0.95,
                  maxY: maxPrice * 1.05,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        selectedPrices.length,
                            (index) => FlSpot(index.toDouble(), selectedPrices[index]),
                      ),
                      isCurved: true,
                      color: widget.color,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: widget.color.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
