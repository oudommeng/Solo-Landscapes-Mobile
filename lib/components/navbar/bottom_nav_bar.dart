import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/controllers/navigation_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Obx(
              () => BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_outlined),
                    label: 'Experiences',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.style_outlined),
                    label: 'Travel Styles',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events_outlined),
                    label: 'Challenges',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz_outlined),
                    label: 'More',
                  ),
                ],
                currentIndex: controller.selectedIndex.value,
                selectedItemColor: const Color(0xFF4A7C59),
                unselectedItemColor: Colors.grey[400],
                onTap: (index) {
                  controller.changeTabIndex(index);
                },
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                elevation: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}
