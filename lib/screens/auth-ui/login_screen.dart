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

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
      ),
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("Welcome",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
                  Text("Please enter your data to continue",style: TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'Inter'),),
                ],
              ),

             Column(
               children: [
               Obx(()=>  Container(
                   margin: EdgeInsets.symmetric(horizontal: 5.0),
                   width: Get.width,
                   child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: TextFormField(
                       textInputAction: TextInputAction.next,
                       cursorColor: AppConstant.appSecondaryColor,
                       keyboardType: TextInputType.emailAddress,
                       decoration: InputDecoration(
                         hintText: 'Email',
                         prefixIcon: Icon(Icons.email),
                         errorText: loginController.emailErrorText.value
                       ),
                       onChanged: (value){
                         loginController.emailController.value=value;
                         loginController.validateEmailInput();
                       },
                     ),
                   )),),
                 Container(
                     margin: EdgeInsets.symmetric(horizontal: 5.0),
                     width: Get.width,
                     child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Obx(() => TextFormField(
                           textInputAction: TextInputAction.next,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.emailAddress,
                           obscureText: loginController.isPasswordVisible.value,
                           decoration: InputDecoration(
                             hintText: 'Password',
                             prefixIcon: Icon(Icons.password),
                             errorText: loginController.passwordErrorText.value,
                             suffixIcon: InkWell(
                               onTap: (){
                                 loginController.isPasswordVisible.toggle();
                               },
                               child: loginController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                             ),

                           ),
                           onChanged: (value){
                             loginController.passwordController.value=value;
                             loginController.validatePasswordInput();
                           },
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
                         color: Colors.red,
                         fontWeight: FontWeight.bold,
                           fontFamily: 'Inter'
                       ),),
                   ),
                 ),
               ],
             ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('By connecting your account confirm that you agree',style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Inter'),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('with our',style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Inter'),),
                      SizedBox(width: 2,),
                      Text('Term and Condition',style: TextStyle(color: Colors.blue.shade800,fontSize: 12,fontFamily: 'Inter'),),
                    ],
                  )

                ],
              )
            ],
          ),
        ),

        bottomSheet: InkWell(
          onTap: ()async{
            bool isEmailValid=loginController.validateEmailInput();
            bool isPasswordValid=loginController.validatePasswordInput();
            if(isEmailValid && isPasswordValid){
              final email=loginController.emailController.value.trim();
              final password=loginController.passwordController.value.trim();


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


            }else{
              Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
            }

          },
          child: Container(
            height: 60,
            width: double.infinity,
            color: AppConstant.appMainColor,
            child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'Inter'),)),
          ),
        ),
      );



  }
}
