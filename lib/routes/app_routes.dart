import 'package:get/get.dart';
import 'package:sololandscapes_moblie/screens/home/home_screen.dart';
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
      page: () => const HomeScreen(),
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
