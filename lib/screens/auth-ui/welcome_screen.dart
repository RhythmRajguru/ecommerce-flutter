import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/google_signin_controller.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/auth-ui/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';

class WelcomeScreen extends StatelessWidget {


  final GoogleSignInController _googleSignInController=Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Let's get Started",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),

             Column(
               children: [
                 Material(child: Container(
                   width: 300,
                   height: 50,
                   decoration: BoxDecoration(
                     color: Color(0xFFEA4335),
                     borderRadius: BorderRadius.circular(20.0),
                   ),
                   child: TextButton.icon(
                     icon: Image.asset('assets/icons/google.png',width: 23,height: 23,),
                     label: Text('Sign in with Google',style: TextStyle(color: Colors.white,fontFamily: 'Inter'),),
                     onPressed: (){
                       _googleSignInController.signInwithGoogle();
                     },
                   ),
                 ),),
                 SizedBox(height: 20),
                 Material(child: Container(
                   width: 300,
                   height: 50,
                   decoration: BoxDecoration(
                     color: Colors.blue,
                     borderRadius: BorderRadius.circular(20.0),
                   ),
                   child: TextButton.icon(
                     icon: Icon(Icons.email,color: Colors.white,size: 25,),
                     label: Text('Sign in with Email',style: TextStyle(color: Colors.white,fontFamily: 'Inter'),),
                     onPressed: (){
                       Get.to(LoginScreen());
                     },
                   ),
                 ),),
               ],
             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',style: TextStyle(color: Colors.grey,fontFamily: 'Inter'),),
                  SizedBox(width: 2,),
                  InkWell(
                      onTap: (){
                        Get.to(()=>LoginScreen());
                      },
                      child: Text('Login',style: TextStyle(color: Colors.black,fontFamily: 'Inter'),)),
                ],
              )
            ],
          ),
        ),

      ),
      bottomSheet: CustomBottomBtn(title: 'Create an Account', callback: (){
        Get.to(()=>RegisterScreen());
      })
    );
  }
}
