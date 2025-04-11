import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text('Admin Panel'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: ()async{
              GoogleSignIn googleSignIn=GoogleSignIn();
              FirebaseAuth _auth=FirebaseAuth.instance;

              await _auth.signOut();

              await googleSignIn.signOut();
              Get.offAll(()=>WelcomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout,),
            ),
          )
        ],
      ),
    );
  }
}
