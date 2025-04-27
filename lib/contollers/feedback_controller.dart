import 'package:get/get.dart';

class FeedbackController extends GetxController{

  RxDouble currentValue=3.0.obs;

  var reviewController = ''.obs;
  var reviewErrorText = RxnString();

  bool validateReviewInput() {
    if (reviewController.value.isEmpty) {
      reviewErrorText.value = 'Please enter something';
      return false;
    } else {
      reviewErrorText.value = null; // no error
      return true;
    }
  }
}