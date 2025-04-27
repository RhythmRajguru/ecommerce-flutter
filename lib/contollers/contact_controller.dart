import 'package:get/get.dart';

class ContactController extends GetxController{
  RxDouble currentValue=3.0.obs;

  var queryController = ''.obs;
  var queryErrorText = RxnString();

  bool validateReviewInput() {
    if (queryController.value.isEmpty) {
      queryErrorText.value = 'Please enter something';
      return false;
    } else {
      queryErrorText.value = null; // no error
      return true;
    }
  }
}