import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/screens/main_layout.dart';
import 'package:sololandscapes_moblie/screens/all_tours/all_tours_screen.dart';
import 'package:sololandscapes_moblie/screens/tour_details/tour_details_screen.dart';
import 'package:sololandscapes_moblie/screens/login_screen/login_screen.dart';
import 'package:sololandscapes_moblie/bindings/tours_binding.dart';

class AppRoutes {
  static const String home = '/home';
  static const String allTours = '/all-tours';
  static const String tourDetails = '/tour-details';
  static const String login = '/login';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const MainLayout(),
      binding: ToursBinding(),
    ),
    GetPage(
      name: allTours,
      page: () => const AllToursScreen(),
      binding: ToursBinding(),
    ),
    GetPage(name: tourDetails, page: () => const TourDetailsScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
  ];
}

// Placeholder screen for bottom navigation items
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4A7C59),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
