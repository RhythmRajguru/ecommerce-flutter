import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddProductController extends GetxController{

  var formatted;

  RxList<TextEditingController> imageControllers = <TextEditingController>[].obs;

  void addImageField() {
    imageControllers.add(TextEditingController());
  }

  List<String> get imageUrls =>
      imageControllers.map((controller) => controller.text.trim()).where((url) => url.isNotEmpty).toList();

  RxList<TextEditingController> sizeController = <TextEditingController>[].obs;

  void addSizeField() {
    sizeController.add(TextEditingController());
  }

  List<String> get productSizes =>
      sizeController.map((controller) => controller.text.trim()).where((size) => size.isNotEmpty).toList();


  final TextEditingController productIdController = TextEditingController();
  var productIdErrorText = RxnString();

  final TextEditingController dateTimeController = TextEditingController();

  var categoryIdController = ''.obs;
  var categoryIdErrorText = RxnString();

  var categoryNameController = ''.obs;
  var categoryNameErrorText = RxnString();

  var productNameController = ''.obs;
  var productNameErrorText = RxnString();

  var productIsSaleController = ''.obs;
  var productIsSaleErrorText = RxnString();

  var productSalePriceController = ''.obs;
  var productSalePriceErrorText = RxnString();

  var productFullPriceController = ''.obs;
  var productFullPriceErrorText = RxnString();

  var productDeliveryTimeController = ''.obs;
  var productDeliveryTimeErrorText = RxnString();

  var productDescriptionController = ''.obs;
  var productDescriptionErrorText = RxnString();


  bool validateCategoryIdInput() {
    if (categoryIdController.value.isEmpty) {
      categoryIdErrorText.value = 'Please enter something';
      return false;
    }
    else if (categoryIdController.value.length<15) {
      categoryIdErrorText.value = 'Please enter at least 20 characters';
      return false;
    }
    else {
      categoryIdErrorText.value = null; // no error
      return true;
    }
  }

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



  bool validateProductNameInput() {
    if (productNameController.value.isEmpty) {
      productNameErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productNameErrorText.value = null; // no error
      return true;
    }
  }


  bool validateProductIsSaleInput() {
    if (productIsSaleController.value.isEmpty) {
      productIsSaleErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productIsSaleErrorText.value = null; // no error
      return true;
    }
  }

  bool validateProductSalePriceInput() {
    if (productSalePriceController.value.isEmpty) {
      productSalePriceErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productSalePriceErrorText.value = null; // no error
      return true;
    }
  }

  bool validateProductFullPriceInput() {
    if (productFullPriceController.value.isEmpty) {
      productFullPriceErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productFullPriceErrorText.value = null; // no error
      return true;
    }
  }

  bool validateProductDeliveryTimeInput() {
    if (productDeliveryTimeController.value.isEmpty) {
      productDeliveryTimeErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productDeliveryTimeErrorText.value = null; // no error
      return true;
    }
  }

  bool validateProductDescriptionInput() {
    if (productDescriptionController.value.isEmpty) {
      productDescriptionErrorText.value = 'Please enter something';
      return false;
    }
    else {
      productDescriptionErrorText.value = null; // no error
      return true;
    }
  }


  void generateRandomCategoryId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random rnd = Random();
    final randomValue = String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );

    productIdController.text = randomValue;
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
         formatted = Timestamp.fromDate(fullDateTime);

        dateTimeController.text = formatted.toString(); // you can format it as needed
      }
    }
  }
}