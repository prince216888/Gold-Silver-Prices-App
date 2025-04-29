import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;

  RefreshButton({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh, color: Colors.white),
      onPressed: onRefresh,
    );
  }
}
