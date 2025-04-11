import 'package:ecom/contollers/get_user_data_controller.dart';
import 'package:ecom/contollers/login_controller.dart';
import 'package:ecom/screens/admin-panel/admin_main_screen.dart';
import 'package:ecom/screens/auth-ui/forgot_password_Screen.dart';
import 'package:ecom/screens/auth-ui/register_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final LoginController loginController=Get.put(LoginController());
  final GetUserDataController getUserDataController=Get.put(GetUserDataController());

  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (p0, isKeyboardVisible) {
      return Scaffold(
          appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: Text('Sign In',
          style: TextStyle(color: AppConstant.appTextColor),),
      ),
      body: Container(
      child: Column(
        children: [
          isKeyboardVisible?SizedBox.shrink():
          Column(
            children: [
              Container(height: Get.height/2.5,width: Get.width,color: AppConstant.appMainColor,child: Lottie.asset('assets/images/splash-icon.json',)),
            ],
          ),
          SizedBox(height: Get.height/30,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  cursorColor: AppConstant.appSecondaryColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ),
                ),
              )),
          SizedBox(height: Get.height/70,),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(()=>TextFormField(
                  controller: passwordController,
                  cursorColor: AppConstant.appSecondaryColor,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: loginController.isPasswordVisible.value,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: InkWell(
                        onTap: (){
                          loginController.isPasswordVisible.toggle();
                        },
                        child: loginController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),
                ),)
              )),
          InkWell(
            onTap: (){
              Get.to(ForgotPasswordScreen());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.centerRight,
              child: Text("Forgot Password?",
              style: TextStyle(
                color: AppConstant.appSecondaryColor,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          SizedBox(height: Get.height/20,),
          Material(child: Container(
            width: Get.width/2,
            height: Get.height/18,
            decoration: BoxDecoration(
              color: AppConstant.appSecondaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              child: Text('Sign In',style: TextStyle(color: AppConstant.appTextColor),),
              onPressed: ()async{
                final email=emailController.text.trim();
                final password=passwordController.text.trim();
                if(email.isEmpty || password.isEmpty){
                  Get.snackbar("Error", "Please enter all details",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
                }else{
                 UserCredential? userCredential=await loginController.LoginMethod(email,password);

                 var userData=await getUserDataController.getUserData(userCredential!.user!.uid);

                 if(userCredential!=null){
                   if(userCredential.user!.emailVerified){
                      if(userData[0]['isAdmin']==true){
                        Get.offAll(()=>AdminMainScreen());
                        Get.snackbar("Success admin login", "login successfully",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

                      }else{
                        Get.offAll(()=>MainScreen());
                        Get.snackbar("Success user login", "login successfully",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

                      }

                   }else{
                     Get.snackbar("Error", "Please verify your email before login",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

                   }
                 }
                 else{
                   Get.snackbar("Error", "Please try again",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

                 }

                }

              },
            ),
          ),),
          SizedBox(height: Get.height/30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Don't have an account? ",style: TextStyle(color: AppConstant.appSecondaryColor),),
            InkWell(
              onTap: (){
                Get.to(RegisterScreen());
              },
                child: Text("Sign Up",style: TextStyle(color: AppConstant.appSecondaryColor,fontWeight: FontWeight.bold),)),
          ],)
        ],
      ),
      ),);
    },);


  }
}
