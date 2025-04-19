import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
 final nameController=TextEditingController();
 final emailController=TextEditingController();
 final queryController=TextEditingController();

 User? user=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Add review', style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              readOnly: true,
              initialValue: user!.displayName,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
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
            child: TextFormField(
              maxLines: 3,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              controller: queryController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.report_problem_outlined),
                labelText: 'Enter your Query',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(height: 40,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppConstant.appMainColor),onPressed: (){
                if(queryController.text.isNotEmpty){
                  pushQuery(queryController.text.toString().trim());
                  Get.offAll(()=>MainScreen());
                }else{
                  Get.snackbar('Error', 'Please enter your query',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppConstant.appMainColor);
                }


          }, child: Text('Submit',style: TextStyle(color: Colors.white),)),
        ],
      ),
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
