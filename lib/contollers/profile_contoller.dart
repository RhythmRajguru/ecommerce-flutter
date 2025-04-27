import 'package:get/get.dart';

class ProfileController extends GetxController{
  var isPasswordVisible=false.obs;

  var oldPasswordController = ''.obs;
  var oldPasswordErrorText = RxnString();

  var newPasswordController = ''.obs;
  var newPasswordErrorText = RxnString();

  bool validateOldPasswordInput() {
    if (oldPasswordController.value.isEmpty) {
      oldPasswordErrorText.value = 'Please enter something';
      return false;
    } else if (oldPasswordController.value.length < 8) {
      oldPasswordErrorText.value = 'Minimum 8 characters required';
      return false;
    } else {
      oldPasswordErrorText.value = null; // no error
      return true;
    }
  }

  bool validateNewPasswordInput() {
    if (newPasswordController.value.isEmpty) {
      newPasswordErrorText.value = 'Please enter something';
      return false;
    } else if (newPasswordController.value.length < 8) {
      newPasswordErrorText.value = 'Minimum 8 characters required';
      return false;
    } else {
      newPasswordErrorText.value = null; // no error
      return true;
    }
  }
}