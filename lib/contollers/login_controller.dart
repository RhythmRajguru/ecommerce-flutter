import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginController extends GetxController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

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
}