import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    print('NavigationController: Changing tab to index $index');
    selectedIndex.value = index;
  }

  void setCurrentIndex(int index) {
    print('NavigationController: Setting current index to $index');
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    print('NavigationController: Initialized');
  }

  @override
  void onClose() {
    print('NavigationController: Disposed');
    super.onClose();
  }
}
