import 'dart:async';

import 'package:ecom/contollers/get_user_data_controller.dart';
import 'package:ecom/screens/admin-panel/admin_main_screen.dart';
import 'package:ecom/screens/auth-ui/gender_screen.dart';
import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
      skipLogin(context);
    });
  }
  Future<void> skipLogin(BuildContext context)async{

    if(user!=null){

      final GetUserDataController getUserDataController=Get.put(GetUserDataController());
      var userData=await getUserDataController.getUserData(user!.uid);

      if(userData[0]['isAdmin']==true){
        Get.offAll(()=>AdminMainScreen());
      }else{
        Get.offAll(()=>MainScreen());
      }

    }else{
      Get.offAll(()=>GenderScreen());
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF9775FA),
      body: Container(
        child: Column(
          children: [

            Expanded(
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
                child: Lottie.asset('assets/images/splash-icon.json'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                'Powered by Rhythm',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
