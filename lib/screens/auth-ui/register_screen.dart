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

  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final cityController=TextEditingController();
  final passwordController=TextEditingController();

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
                   Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,
                           controller: nameController,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.name,
                           decoration: InputDecoration(
                             hintText: 'Username',
                             prefixIcon: Icon(Icons.person),

                           ),
                         ),
                       )),

                   Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,
                           controller: emailController,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.emailAddress,
                           decoration: InputDecoration(
                             hintText: 'Email',
                             prefixIcon: Icon(Icons.email),

                           ),
                         ),
                       )),

                   Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,
                           controller: phoneController,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.phone,
                           decoration: InputDecoration(
                             hintText: 'Phone',
                             prefixIcon: Icon(Icons.phone),

                           ),
                         ),
                       )),

                   Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: TextFormField(
                           textInputAction: TextInputAction.next,
                           controller: cityController,
                           cursorColor: AppConstant.appSecondaryColor,
                           keyboardType: TextInputType.streetAddress,
                           decoration: InputDecoration(
                             hintText: 'City',
                             prefixIcon: Icon(Icons.location_pin),

                           ),
                         ),
                       )),

                   Container(
                       margin: EdgeInsets.symmetric(horizontal: 5.0),
                       width: Get.width,
                       child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Obx(() => TextFormField(
                             textInputAction: TextInputAction.next,
                             controller: passwordController,
                             cursorColor: AppConstant.appSecondaryColor,
                             keyboardType: TextInputType.emailAddress,
                             obscureText: registerController.isPasswordVisible.value,
                             decoration: InputDecoration(
                               hintText: 'Password',
                               prefixIcon: Icon(Icons.password),
                               suffixIcon: InkWell(
                                 onTap: (){
                                   registerController.isPasswordVisible.toggle();
                                 },
                                 child: registerController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                               ),

                             ),
                           ),)
                       )),
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
            NotificationService notificationService=NotificationService();

            String name=nameController.text.trim();
            String email=emailController.text.trim();
            String phone=phoneController.text.trim();
            String city=cityController.text.trim();
            String password=passwordController.text.trim();
            String userDeviceToken=await notificationService.getDeviceToken();
            if(name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || password.isEmpty){
              Get.snackbar("Error", "Please enter all details",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
            }
          else{
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
