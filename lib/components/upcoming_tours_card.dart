import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/unit/font.dart';

class UpcomingToursList extends StatelessWidget {
  final List<Map<String, dynamic>> tours; // Changed to Map<String, dynamic>

  const UpcomingToursList({super.key, required this.tours});

  String formatDateRange(String startDate, String endDate) {
    try {
      if (startDate.isEmpty || endDate.isEmpty) return '';

      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final startMonth = months[start.month - 1];
      final endMonth = months[end.month - 1];

      if (start.year == end.year) {
        if (start.month == end.month) {
          return '$startMonth ${start.day} – ${end.day}, ${start.year}';
        } else {
          return '$startMonth ${start.day} – $endMonth ${end.day}, ${start.year}';
        }
      } else {
        return '$startMonth ${start.day}, ${start.year} – $endMonth ${end.day}, ${end.year}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tours.length,
        itemBuilder: (context, index) {
          final tour = tours[index];
          print(
            'Loading image for tour ${tour['title']}: ${tour['image']} (type: ${tour['image']?.runtimeType})',
          );
          return Container(
            width: 320,
            margin: const EdgeInsets.only(right: 2),
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  // Navigate to tour details using GetX, passing the full tour map
                  Get.toNamed('/tour-details', arguments: tour);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: tour['image']?.toString().isNotEmpty ?? false
                            ? Image.network(
                                tour['image'].toString(),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Image load error: $error');
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey[600],
                                      size: 40,
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  print(
                                    'Image loading progress: ${loadingProgress.cumulativeBytesLoaded} / ${loadingProgress.expectedTotalBytes}',
                                  );
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 150,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey[600],
                                  size: 40,
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tour['title']?.toString() ?? 'No Title',
                        style: KantumruyFont.bold(
                          fontSize: 18,
                          color: primary600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 17,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tour['isEveryday'] == true ||
                                      tour['isEveryday'] == 'true'
                                  ? 'Everyday'
                                  : formatDateRange(
                                      tour['startDate']?.toString() ?? '',
                                      tour['endDate']?.toString() ?? '',
                                    ),
                              style: KantumruyFont.regular(
                                color: Colors.grey[600],
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 17,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tour['destination']?.toString() ??
                                  'Unknown Location',
                              style: KantumruyFont.regular(
                                color: Colors.grey[600],
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${(tour['price'] is double ? tour['price'] : double.tryParse(tour['price']?.toString() ?? '0') ?? 0.0).toStringAsFixed(0)} per person',
                                style: KantumruyFont.regular(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6B8E23),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
