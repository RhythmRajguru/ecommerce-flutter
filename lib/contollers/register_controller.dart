import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/userModel.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  var isPasswordVisible=false.obs;

  var usernameController = ''.obs;
  var usernameErrorText = RxnString(); // nullable observable string

  var emailController = ''.obs;
  var emailErrorText = RxnString(); // nullable observable string
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  var phoneController = ''.obs;
  var phoneErrorText = RxnString(); // nullable observable string

  var cityController = ''.obs;
  var cityErrorText = RxnString(); // nullable observable string

  var passwordController = ''.obs;
  var passwordErrorText = RxnString();

  Future<UserCredential?> RegisterMethod(
      String userName,
      String userEmail,
      String userPhone,
      String userCity,
      String userPassword,
      String userDeviceToken,)
  async{
  try{
    EasyLoading.show(status: "Please wait..");

    UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

    await userCredential.user!.sendEmailVerification();

    UserModel userModel=UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        userDeviceToken: userDeviceToken,
        country: '',
        city: userCity,
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now());

    _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
    EasyLoading.dismiss();
    return userCredential;
    
  }on FirebaseAuthException catch(e){
    EasyLoading.dismiss();
    Get.snackbar("Error", "$e",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
  }

  }
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
  bool validateCityInput() {
    if (cityController.value.isEmpty) {
      cityErrorText.value = 'Please enter something';
      return false;
    } else {
      cityErrorText.value = null; // no error
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