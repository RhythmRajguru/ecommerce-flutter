import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgotPasswordController extends GetxController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<void> ForgetPasswordMethod(
      String userEmail,
      )
  async{
    try{
      EasyLoading.show(status: "Please wait..");

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar("Request send Successfully", "Password reset link sent to $userEmail",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

      Get.offAll(()=>LoginScreen());

      EasyLoading.dismiss();

    }on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
    }

  }
}