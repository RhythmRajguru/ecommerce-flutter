import 'package:ecom/contollers/register_controller.dart';
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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: Text('Sign Up',
            style: TextStyle(color: AppConstant.appTextColor),),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20.0,left: 5.0,right: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: nameController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: 'Username',
                            contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                            prefixIcon: Icon(Icons.person),
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
                      child: TextFormField(
                        controller: phoneController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: 'Phone',
                            contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                            prefixIcon: Icon(Icons.phone),
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
                      child: TextFormField(
                        controller: cityController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            hintText: 'City',
                            contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                            prefixIcon: Icon(Icons.location_pin),
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
                      child: Obx(() => TextFormField(
                        controller: passwordController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: registerController.isPasswordVisible.value,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: InkWell(
                              onTap: (){
                                registerController.isPasswordVisible.toggle();
                              },
                              child: registerController.isPasswordVisible.value?Icon(Icons.visibility_off):Icon(Icons.visibility_sharp),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        ),
                      ),)
                    )),
                SizedBox(height: Get.height/20,),
                Material(child: Container(
                  width: Get.width/2,
                  height: Get.height/18,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text('Sign Up',style: TextStyle(color: AppConstant.appTextColor),),
                    onPressed: ()async{
                      String name=nameController.text.trim();
                      String email=emailController.text.trim();
                      String phone=phoneController.text.trim();
                      String city=cityController.text.trim();
                      String password=passwordController.text.trim();
                      String userDeviceToken='';
                    if(name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || password.isEmpty){
                      Get.snackbar("Error", "Please enter all details",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
                    }else{
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
                  ),
                ),),
                SizedBox(height: Get.height/20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",style: TextStyle(color: AppConstant.appSecondaryColor),),
                    InkWell(
                        onTap: (){
                          Get.to(LoginScreen());
                        },
                        child: Text("Sign In",style: TextStyle(color: AppConstant.appSecondaryColor,fontWeight: FontWeight.bold),)),
                  ],)
              ],
            ),
          ),
        ),);
    },);
  }
}
