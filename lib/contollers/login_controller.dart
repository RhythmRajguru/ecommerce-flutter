import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginController extends GetxController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  var emailController = ''.obs;
  var emailErrorText = RxnString(); // nullable observable string
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  var passwordController = ''.obs;
  var passwordErrorText = RxnString();

  var isPasswordVisible=false.obs;

  Future<UserCredential?> LoginMethod(
      String userEmail,
      String userPassword,
      )
  async{
    try{
      EasyLoading.show(status: "Please wait..");

      UserCredential userCredential=await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      
      EasyLoading.dismiss();
      return userCredential;

    }on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
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

  bool validatePasswordInput() {
    if (passwordController.value.isEmpty) {
      passwordErrorText.value = 'Please enter something';
      return false;
    } else if (passwordController.value.length < 8) {
      passwordErrorText.value = 'Minimum 8 characters required';
      return false;
    } else {
      passwordErrorText.value = null; // no error
      return true;
    }
  }
}