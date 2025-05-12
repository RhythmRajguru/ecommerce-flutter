import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCategoryController extends GetxController{

  final TextEditingController categoryIdController = TextEditingController();

  final TextEditingController dateTimeController = TextEditingController();

  var categoryNameController = ''.obs;
  var categoryNameErrorText = RxnString();

  var categoryImgController = ''.obs;
  var categoryImgErrorText = RxnString();


  bool validateCategoryNameInput() {
    if (categoryNameController.value.isEmpty) {
      categoryNameErrorText.value = 'Please enter something';
      return false;
    }
    else {
      categoryNameErrorText.value = null; // no error
      return true;
    }
  }

  bool validateCategoryImgInput() {
    if (categoryImgController.value.isEmpty) {
      categoryImgErrorText.value = 'Please enter something';
      return false;
    }
    else {
      categoryImgErrorText.value = null; // no error
      return true;
    }
  }

  void generateRandomCategoryId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random rnd = Random();
    final randomValue = String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );

    categoryIdController.text = randomValue;
  }

  Future<void> selectDateTime(BuildContext context) async {
    // Select Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Select Time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
          DateTime.now().second,
        );
        final formatted = DateFormat('dd/MM/yyyy hh:mm:ss').format(fullDateTime);

        // Format and set value to TextField
        dateTimeController.text = formatted; // you can format it as needed
      }
    }
  }
}