import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/controllers/navigation_controller.dart';
import 'package:sololandscapes_moblie/components/navbar/bottom_nav_bar.dart';
import 'package:sololandscapes_moblie/screens/home/home_screen.dart';
import 'package:sololandscapes_moblie/screens/experiences/experiences_screen.dart';
import 'package:sololandscapes_moblie/screens/travel_styles/travel_styles_screen.dart';
import 'package:sololandscapes_moblie/screens/challenges/challenges_screen.dart';
import 'package:sololandscapes_moblie/screens/more/more_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late NavigationController _navController;

  @override
  void initState() {
    super.initState();
    // Initialize the navigation controller
    try {
      _navController = Get.find<NavigationController>();
    } catch (e) {
      _navController = Get.put(NavigationController());
    }

    // Set initial index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navController.setCurrentIndex(0);
    });
  }

  Widget _getCurrentScreen() {
    switch (_navController.selectedIndex.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ExperiencesScreen();
      case 2:
        return const TravelStylesScreen();
      case 3:
        return const ChallengesScreen();
      case 4:
        return const MoreScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getCurrentScreen()),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
