import 'package:flutter/material.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsHex("F1F1F1"),
      appBar: const CustomAppBar(onNotificationPressed: null),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.more_horiz_outlined, size: 64, color: Color(0xFF4A7C59)),
            SizedBox(height: 16),
            Text(
              'More',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A7C59),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Profile & Settings',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
