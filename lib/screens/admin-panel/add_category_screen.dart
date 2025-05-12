import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/add_category_controller.dart';
import 'package:ecom/contollers/contact_controller.dart';
import 'package:ecom/contollers/feedback_controller.dart';
import 'package:ecom/screens/admin-panel/admin_main_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCategoryScreen extends StatelessWidget {


  User? user=FirebaseAuth.instance.currentUser;

  AddCategoryController addCategoryController=Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category',style: TextStyle(fontFamily: 'Inter',fontSize: 20),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Category Id',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  controller: addCategoryController.categoryIdController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter Category Id',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: ()=>addCategoryController.generateRandomCategoryId(20),
                      child: Icon(Icons.refresh),
                    ),
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
                  child: Text('Category Name',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                child:Obx(()=> TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    errorText: addCategoryController.categoryNameErrorText.value,
                    hintText: 'Enter Category Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                  ),
                  onChanged: (value) {
                    addCategoryController.categoryNameController.value=value;
                    addCategoryController.validateCategoryNameInput();
                  },
                )),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Category Img',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                child:Obx(()=> TextFormField(
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    errorText: addCategoryController.categoryImgErrorText.value,
                    hintText: 'Enter Category Img Url',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                  ),
                  onChanged: (value) {
                    addCategoryController.categoryImgController.value=value;
                    addCategoryController.validateCategoryImgInput();
                  },
                )),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10,left: 20),
                  child: Text('Created At',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                child: TextFormField(
                  controller: addCategoryController.dateTimeController,
                  readOnly: true,
                  onTap: ()=>addCategoryController.selectDateTime(context),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter Creation Date & Time',
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
                  child: Text('Updated At',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                child: TextFormField(
                  readOnly: true,
                  controller: addCategoryController.dateTimeController,
                  onTap: ()=>addCategoryController.selectDateTime(context),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter Updation Date & Time',
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
            ],
          ),


        ],
      ),
      bottomSheet: CustomBottomBtn(title: 'Add', callback: ()async{

        bool isNameValid=addCategoryController.validateCategoryNameInput();
        bool isImgValid=addCategoryController.validateCategoryImgInput();


        if(isNameValid && isImgValid ){
          try {
            await FirebaseFirestore.instance
                .collection('categories')
                .doc(addCategoryController.categoryIdController.text.toString()) // Setting custom doc ID
                .set({
              'categoryId': addCategoryController.categoryIdController.text.toString(),
              'categoryName': addCategoryController.categoryNameController.value.toString(),
              'categoryImg': addCategoryController.categoryImgController.value.toString(),
              'createdAt': addCategoryController.dateTimeController.text.toString(),
              'updatedAt': addCategoryController.dateTimeController.text.toString(),
            });
            Get.snackbar('Success', 'Category added with ID: ${addCategoryController.categoryIdController.text.toString()}',snackPosition: SnackPosition.BOTTOM);
            Get.offAll(()=>AdminMainScreen());
          } catch (e) {
            Get.snackbar('Error', 'Error adding category: $e',snackPosition: SnackPosition.BOTTOM);
          }
        }else{
          Get.snackbar('Error', 'Please fill all details',snackPosition: SnackPosition.BOTTOM);
        }
      }),
    );
  }
}
