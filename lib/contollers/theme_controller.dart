import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  // observable variable for dark mode
  RxBool isDarkMode = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}