import 'package:get/get.dart';

class OrderController extends GetxController{
  var usernameController = ''.obs;
  var usernameErrorText = RxnString(); // nullable observable string

  var emailController = ''.obs;
  var emailErrorText = RxnString(); // nullable observable string
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  var stateController = ''.obs;
  var stateErrorText = RxnString();

  var countryController = ''.obs;
  var countryErrorText = RxnString();

  var phoneController = ''.obs;
  var phoneErrorText = RxnString(); // nullable observable string

  var addressController = ''.obs;
  var addressErrorText = RxnString(); // nullable observable string

  RxBool saveAddress=false.obs;

  bool validateUsernameInput() {
    if (usernameController.value.isEmpty) {
      usernameErrorText.value = 'Please enter something';
      return false;
    } else {
      usernameErrorText.value = null; // no error
      return true;
    }
  }
  bool validateEmailInput() {
    if (emailController.value.isEmpty) {
      emailErrorText.value = 'Please enter something';
      return false;
    } else if (!emailRegex.hasMatch(emailController.value)) {
      emailErrorText.value = 'Please enter correct email';
      return false;
    } else {
      emailErrorText.value = null; // no error
      return true;
    }
  }
  bool validateStateInput() {
    if (stateController.value.isEmpty) {
      stateErrorText.value = 'Please enter something';
      return false;
    } else {
      stateErrorText.value = null; // no error
      return true;
    }
  }
  bool validateCountryInput() {
    if (countryController.value.isEmpty) {
      countryErrorText.value = 'Please enter something';
      return false;
    } else {
      countryErrorText.value = null; // no error
      return true;
    }
  }
  bool validatePhoneInput() {
    if (phoneController.value.isEmpty) {
      phoneErrorText.value = 'Please enter something';
      return false;
    } else if (phoneController.value.length < 10) {
      phoneErrorText.value = 'Minimum 10 characters required';
      return false;
    } else {
      phoneErrorText.value = null; // no error
      return true;
    }
  }
  bool validateAddressInput() {
    if (addressController.value.isEmpty) {
      addressErrorText.value = 'Please enter something';
      return false;
    } else {
      addressErrorText.value = null; // no error
      return true;
    }
  }
}