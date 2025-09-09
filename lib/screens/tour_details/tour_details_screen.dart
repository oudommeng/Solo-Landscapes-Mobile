import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/unit/font.dart';

class TourDetailsScreen extends StatelessWidget {
  const TourDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> tour = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: ColorsHex("F1F1F1"),
      appBar: const CustomAppBar(
        onNotificationPressed: null,
        showBackButton: true,
        useUserService: false,
        userName: 'Tour Details',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            SizedBox(
              height: 300,
              width: double.infinity,
              child: tour['image'].toString().isNotEmpty
                  ? Image.network(
                      tour['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 64,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 64,
                      ),
                    ),
            ),

            // Tour details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour['title'] ?? 'No Title',
                    style: KantumruyFont.bold(fontSize: 24, color: primary600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${tour['rating']} (${tour['reviews']} reviews)',
                        style: KantumruyFont.medium(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tour['isEveryday'] == true
                            ? 'Available Everyday'
                            : '${tour['startDate']} - ${tour['endDate']}',
                        style: KantumruyFont.regular(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Price section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsHex("F1F1F1"),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price per person',
                              style: KantumruyFont.regular(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${tour['price']?.toStringAsFixed(0) ?? '0'}',
                              style: KantumruyFont.bold(
                                fontSize: 28,
                                color: const Color(0xFF6B8E23),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.snackbar(
                              'Booking',
                              'Booking functionality coming soon!',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B8E23),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: KantumruyFont.bold(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description placeholder
                  Text(
                    'About this tour',
                    style: KantumruyFont.bold(fontSize: 18, color: primary600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Experience the best of ${tour['title']} with our expertly guided tour. This adventure offers breathtaking views, cultural insights, and unforgettable memories.',
                    style: KantumruyFont.regular(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
