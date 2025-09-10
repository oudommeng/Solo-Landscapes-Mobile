import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/unit/font.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';
import 'package:sololandscapes_moblie/components/upcoming_tours_card.dart';
import 'package:sololandscapes_moblie/controllers/tours_controller.dart';

// Main widget for the home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State to keep track of the selected tab in the bottom navigation bar
  int _selectedIndex = 0;
  late ToursController _toursController;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller or create one
    try {
      _toursController = Get.find<ToursController>();
    } catch (e) {
      _toursController = Get.put(ToursController());
    }

    // Initialize controller with GraphQL client after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GraphQLClient? client = GraphQLProvider.of(context).value;
      if (client != null) {
        _toursController.setGraphQLClient(client);
        _toursController.loadTours();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a light grey background color for the entire screen
      backgroundColor: ColorsHex("F1F1F1"),
      appBar: const CustomAppBar(onNotificationPressed: null),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFindTourSection(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSectionHeader(title: 'Upcoming Tour'),
            ),
            const SizedBox(height: 8),
            // Use ToursController for upcoming tours
            Obx(() {
              if (_toursController.isLoading.value &&
                  _toursController.filteredTours.isEmpty) {
                return const SizedBox(
                  height: 340,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_toursController.filteredTours.isEmpty) {
                return const SizedBox(
                  height: 340,
                  child: Center(child: Text('No upcoming tours available')),
                );
              }

              // Take only first 10 tours for home screen
              final tours = _toursController.filteredTours.take(10).toList();
              return UpcomingToursList(tours: tours);
            }),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSectionHeader(title: 'Travel Styles'),
            ),
            const SizedBox(height: 16),
            _buildTravelStylesList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds the "Find Your Tour" section with input fields and a search button
  Widget _buildFindTourSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Your Tour',
          style: KantumruyFont.bold(
            fontSize: 28,
            color: const Color(0xFF4A7C59),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(icon: Icons.person_outline, hintText: 'Anywhere'),
        const SizedBox(height: 16),
        _buildTextField(
          icon: Icons.calendar_today_outlined,
          hintText: 'SUN 7-Sep',
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.search_outlined, color: Colors.white),
            label: Text(
              'Search Your Tour',
              style: KantumruyFont.bold(fontSize: 16),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF6B8E23), // Olive green color
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget to create a styled text field
  Widget _buildTextField({required IconData icon, required String hintText}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: KantumruyFont.regular(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }

  /// Builds the section header with a title and a "See all" button
  Widget _buildSectionHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: KantumruyFont.bold(fontSize: 22, color: primary600)),
        TextButton(
          onPressed: () {
            // Navigate to All Tours screen using GetX named routes
            Get.toNamed(
              '/all-tours',
              arguments: {'client': GraphQLProvider.of(context).value},
            );
          },
          child: Text(
            'See all',
            style: KantumruyFont.bold(color: primary600, fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Builds the horizontal list of "Travel Styles" cards
  Widget _buildTravelStylesList() {
    // Dummy data for travel styles
    final styles = [
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Solo',
      },
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Family',
      },
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Group',
      },
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          print(
            'Loading travel style image for ${style['label']}: ${style['image']}',
          );
          return Card(
            elevation: 2,
            shadowColor: Colors.grey.withValues(alpha: 0.2),
            clipBehavior:
                Clip.antiAlias, // Ensures the image respects the border radius
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: [
                  Image.network(
                    style['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('Travel style image load error: $error');
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      print(
                        'Travel style image loading progress: ${loadingProgress.cumulativeBytesLoaded} / ${loadingProgress.expectedTotalBytes}',
                      );
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      style['label']!,
                      style: KantumruyFont.bold(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
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
        child: BottomNavigationBar(
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
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF4A7C59),
          unselectedItemColor: Colors.grey[400],
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // Ensures all labels are visible
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
    );
  }
}
