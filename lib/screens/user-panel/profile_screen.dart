import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/login_controller.dart';
import 'package:ecom/contollers/profile_contoller.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {

  User? user = FirebaseAuth.instance.currentUser;

  ProfileController profileController=Get.put(ProfileController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: ()async{
                   await user!.delete();
                   Get.snackbar('Success', 'User Deleted Successfully',
                       snackPosition: SnackPosition.BOTTOM,
                       backgroundColor: AppConstant.appMainColor);
                   Get.offAll(()=>LoginScreen());
                  },
                  value: "Delete Account",
                  child: InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Delete Account"),
                      ],
                    ),
                  ),
                ),
              ],
            )

          ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("New Password",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  initialValue: user!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Obx(()=>
                      TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        obscureText: profileController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          prefixIcon: Icon(Icons.password),
                          errorText: profileController.oldPasswordErrorText.value,
                          suffixIcon: InkWell(
                            onTap: (){
                              profileController.isPasswordVisible.toggle();
                            },
                            child: profileController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                        onChanged: (value) {
                          profileController.oldPasswordController.value=value;
                          profileController.validateOldPasswordInput();
                        },
                      ),)
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Obx(()=>TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,

                    obscureText: profileController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.password),
                      errorText: profileController.newPasswordErrorText.value,
                      suffixIcon: InkWell(
                        onTap: (){
                          profileController.isPasswordVisible.toggle();
                        },
                        child: profileController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    onChanged: (value) {
                      profileController.newPasswordController.value=value;
                      profileController.validateNewPasswordInput();
                    },
                  ),)
              ),
            ],
          ),
          Text("Please write your new password.",style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Inter'),),
        ],
      ),
      bottomSheet:CustomBottomBtn(title: 'Reset Password', callback: ()async{
        final isOldPasswordValid=profileController.validateOldPasswordInput();
        final isNewPasswordValid=profileController.validateNewPasswordInput();


       if(isOldPasswordValid && isNewPasswordValid){
         AuthCredential credential = EmailAuthProvider.credential(
           email: user!.email.toString(),
           password: profileController.oldPasswordController.value.toString().trim(),
         );

         await user!.reauthenticateWithCredential(credential);

         await user!.updatePassword(profileController.newPasswordController.value.toString().trim());

         Get.snackbar("Success", "Password updated Successfully",snackPosition: SnackPosition.BOTTOM,colorText: Colors.black);
          Get.offAll(()=>MainScreen());
       }else{
         Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,colorText: Colors.black);
       }
      })
    );
  }
}