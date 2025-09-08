import 'package:flutter/material.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex("EBEBEB"),
      appBar: CustomAppBar(
        showBackButton: true, // Show back button for non-home screens
        onNotificationPressed: () {
          // Handle notification tap for settings screen
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Notifications'),
              content: const Text('You have 3 new notifications'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A7C59),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This screen demonstrates how to customize the notification behavior while using the same AppBar.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
