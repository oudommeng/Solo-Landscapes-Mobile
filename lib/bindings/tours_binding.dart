import 'package:get/get.dart';
import 'package:sololandscapes_moblie/controllers/tours_controller.dart';
import 'package:sololandscapes_moblie/controllers/navigation_controller.dart';

class ToursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToursController>(() => ToursController());
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
