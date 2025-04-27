import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/contact_controller.dart';
import 'package:ecom/contollers/feedback_controller.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {


 User? user=FirebaseAuth.instance.currentUser;
  ContactController contactController=Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Submit a Query',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 20),),
          Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Name',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  readOnly: true,
                  initialValue: user!.displayName,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Email',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  initialValue: user!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Query',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child:Obx(()=> TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter your Query',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                    errorText: contactController.queryErrorText.value,
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                  ),
                  onChanged: (value) {
                    contactController.queryController.value=value;
                    contactController.validateReviewInput();
                  },
                )),
              ),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please write your Query here and",style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Inter'),),
              Text("we will try to fix it ASAP.",style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Inter'),),
            ],
          )
        ],
      ),
      bottomSheet: CustomBottomBtn(title: 'Send Query', callback: ()async{
        bool isQueryValid=contactController.validateReviewInput();
        if(isQueryValid){
          await FirebaseFirestore.instance.collection('users').doc(
              user!.uid).
          collection('query').doc(user!.uid).set(
              {'query': contactController.queryController.value.toString()}
          );
          Get.snackbar('Success', 'Query submitted successfully',
              snackPosition: SnackPosition.BOTTOM,);
          Get.offAll(()=>MainScreen());
        }else{
          Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,colorText: Colors.black);
        }
      }),
    );
  }

  Future<void> pushQuery(String query)async {

        await FirebaseFirestore.instance.collection('users').doc(
            user!.uid).
        collection('query').doc(user!.uid).set(
            {'query': query}
        );

        Get.snackbar('Success', 'Query submitted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppConstant.appMainColor);
  }
}
