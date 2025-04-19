import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/contollers/login_controller.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final queryController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  LoginController loginController=Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Profile', style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
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
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              initialValue: user!.email,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(()=>
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: oldPasswordController,
                  obscureText: loginController.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: InkWell(
                      onTap: (){
                        loginController.isPasswordVisible.toggle();
                      },
                      child: loginController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                ),)
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(()=>TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: newPasswordController,
              obscureText: loginController.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.password),
                suffixIcon: InkWell(
                  onTap: (){
                    loginController.isPasswordVisible.toggle();
                  },
                  child: loginController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),)
          ),
          SizedBox(height: 40,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor), onPressed: () {
            if (oldPasswordController.text.isNotEmpty &&
                newPasswordController.text.isNotEmpty) {
              changePassword();
              Get.snackbar('Success', 'Password updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppConstant.appMainColor);
              oldPasswordController.clear();
              newPasswordController.clear();
            } else {
              Get.snackbar('Error', 'Please enter all details',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppConstant.appMainColor);
            }
          }, child: Text('Update Password', style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }
  Future<void> changePassword()async{
    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email.toString(),
      password: oldPasswordController.text.toString().trim(),
    );

    await user!.reauthenticateWithCredential(credential);

    await user!.updatePassword(newPasswordController.text.toString().trim());
  }

}