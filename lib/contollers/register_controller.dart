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
}