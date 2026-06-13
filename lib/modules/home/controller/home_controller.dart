import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final isDarkMode = true.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read<bool>('isDarkMode') ?? true;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  AuthController get authController => Get.find<AuthController>();
}
