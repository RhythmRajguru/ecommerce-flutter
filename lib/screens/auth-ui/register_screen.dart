import 'package:ecom/contollers/register_controller.dart';
import 'package:ecom/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final RegisterController registerController=Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (p0, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(),
        body:  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Sign Up",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
               Column(
                 children: [
                   Obx(()=>Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,

                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.name,
                           decoration: InputDecoration(
                               hintText: 'Username',
                               prefixIcon: Icon(Icons.person),
                               errorText: registerController.usernameErrorText.value
                           ),
                           onChanged: (value){
                             registerController.usernameController.value=value;
                             registerController.validateUsernameInput();
                           },
                         ),
                       )),),

                   Obx(()=>Container(
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
                               errorText: registerController.emailErrorText.value

                           ),
                           onChanged: (value){
                             registerController.emailController.value=value;
                             registerController.validateEmailInput();
                           },
                         ),
                       ))),

                   Obx(()=>Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.phone,
                           decoration: InputDecoration(
                             hintText: 'Phone',
                             prefixIcon: Icon(Icons.phone),
                               errorText: registerController.phoneErrorText.value
                           ),
                           onChanged: (value){
                             registerController.phoneController.value=value;
                             registerController.validatePhoneInput();
                           },
                         ),
                       ))),

                   Obx(()=>Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,

                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.streetAddress,
                           decoration: InputDecoration(
                             hintText: 'City',
                             prefixIcon: Icon(Icons.location_pin),
                               errorText: registerController.cityErrorText.value
                           ),
                           onChanged: (value){
                             registerController.cityController.value=value;
                             registerController.validateCityInput();
                           },
                         ),
                       ))),

                   Obx(()=>Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: TextFormField(
                             textInputAction: TextInputAction.next,

                             cursorColor: AppConstant.appSecondaryColor,
                             keyboardType: TextInputType.emailAddress,
                             obscureText: registerController.isPasswordVisible.value,
                             decoration: InputDecoration(
                               hintText: 'Password',
                                 errorText: registerController.passwordErrorText.value,
                               prefixIcon: Icon(Icons.password),

                               suffixIcon: InkWell(
                                 onTap: (){
                                   registerController.isPasswordVisible.toggle();
                                 },
                                 child: registerController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                               ),

                             ),
                             onChanged: (value){
                               registerController.passwordController.value=value;
                               registerController.validatePasswordInput();
                             },
                           ),
                       ))),
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
            bool isUsernameValid=registerController.validateUsernameInput();
            bool isEmailValid=registerController.validateEmailInput();
            bool isPhoneValid=registerController.validatePhoneInput();
            bool isCityValid=registerController.validateCityInput();
            bool isPasswordValid=registerController.validatePasswordInput();

            if(isUsernameValid && isEmailValid && isPhoneValid && isCityValid && isPasswordValid){
              NotificationService notificationService=NotificationService();

              String name=registerController.usernameController.value.trim();
              String email=registerController.emailController.value.trim();
              String phone=registerController.phoneController.value.trim();
              String city=registerController.cityController.value.trim();
              String password=registerController.passwordController.value.trim();

              String userDeviceToken=await notificationService.getDeviceToken();

                UserCredential? userCredential=await registerController.RegisterMethod(
                    name,
                    email,
                    phone,
                    city,
                    password,
                    userDeviceToken);
                if(userCredential!=null){
                  Get.snackbar("Verification email sent", "Please check your email",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
                  FirebaseAuth.instance.signOut();

                  Get.offAll(()=>LoginScreen());

                }

            }else{
              Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);

            }

          },
          child: Container(
            height: 60,
            width: double.infinity,
            color: AppConstant.appMainColor,
            child: Center(child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'Inter'),)),
          ),
        ),
      );
    },);
  }
}
