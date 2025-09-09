import 'package:flutter/material.dart';

class UpcomingToursList extends StatelessWidget {
  final List<Map<String, String>> tours;

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
          // Same month and year: "Sep 12 – 14, 2025"
          return '$startMonth ${start.day} – ${end.day}, ${start.year}';
        } else {
          // Different month, same year: "Sep 12 – Oct 14, 2025"
          return '$startMonth ${start.day} – $endMonth ${end.day}, ${start.year}';
        }
      } else {
        // Different years: "Dec 12, 2024 – Jan 14, 2025"
        return '$startMonth ${start.day}, ${start.year} – $endMonth ${end.day}, ${end.year}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tours.length,
        itemBuilder: (context, index) {
          final tour = tours[index];
          print(
            'Loading image for tour ${tour['title']}: ${tour['image']} (type: ${tour['image'].runtimeType})',
          );
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: tour['image']!.isNotEmpty
                          ? Image.network(
                              tour['image']!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Image load error: $error');
                                return Container(
                                  height: 120,
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
                                  'Image loading progress: ${loadingProgress.cumulativeBytesLoaded} / ${loadingProgress.expectedTotalBytes}',
                                );
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              height: 120,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tour['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      tour['isEveryday'] == 'true'
                          ? 'Everyday • \$${tour['price']} per person'
                          : '${formatDateRange(tour['startDate'] ?? '', tour['endDate'] ?? '')} • \$${tour['price']} per person',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tour['rating']}  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tour['reviews']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
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
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
