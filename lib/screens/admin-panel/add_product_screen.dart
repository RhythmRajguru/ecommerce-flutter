import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/add_category_controller.dart';
import 'package:ecom/contollers/add_product_controller.dart';
import 'package:ecom/contollers/contact_controller.dart';
import 'package:ecom/contollers/feedback_controller.dart';
import 'package:ecom/screens/admin-panel/admin_main_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddProductScreen extends StatefulWidget {


  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  User? user=FirebaseAuth.instance.currentUser;

  AddProductController addProductController=Get.put(AddProductController());

  @override
  void initState() {
    super.initState();
    addProductController.addImageField(); // Add one initially
    addProductController.addSizeField(); // Add one initially
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product',style: TextStyle(fontFamily: 'Inter',fontSize: 20),),
      ),
      body: SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.only(bottom: 100),
          child: Column(
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
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.categoryIdErrorText.value,
                        hintText: 'Enter Category Id',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.categoryIdController.value=value;
                        addProductController.validateCategoryIdInput();
                      },
                    )),
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
                        errorText: addProductController.categoryNameErrorText.value,
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
                        addProductController.categoryNameController.value=value;
                        addProductController.validateCategoryNameInput();
                      },
                    )),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('Product Id',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      controller: addProductController.productIdController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Enter Product Id',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        suffixIcon: InkWell(
                          onTap: ()=>addProductController.generateRandomCategoryId(20),
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
                      child: Text('Product Name',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productNameErrorText.value,
                        hintText: 'Enter Product Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productNameController.value=value;
                        addProductController.validateProductNameInput();
                      },
                    )),
                  ),
                  Obx(() => Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10,left: 20),
                          child: Text('Product Images',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                      for (int i = 0; i < addProductController.imageControllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                          child: TextFormField(
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.next,
                            controller: addProductController.imageControllers[i],
                            decoration: InputDecoration(
                              suffixIcon: i == addProductController.imageControllers.length - 1
                                  ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  addProductController.addImageField();
                                },
                              )
                                  : null,
                              hintText: 'Enter Product Img Url',
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
                  )),
                  Obx(() => Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10,left: 20),
                          child: Text('Product Sizes',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                      for (int i = 0; i < addProductController.sizeController.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: addProductController.sizeController[i],
                            decoration: InputDecoration(
                              suffixIcon: i == addProductController.sizeController.length - 1
                                  ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  addProductController.addSizeField();
                                },
                              )
                                  : null,
                              hintText: 'Enter Product Sizes',
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
                  )),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('isSale',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productIsSaleErrorText.value,
                        hintText: "Enter if it's sale or not",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productIsSaleController.value=value;
                        addProductController.validateProductIsSaleInput();
                      },
                    )),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('Sale Price',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productSalePriceErrorText.value,
                        hintText: 'Enter Sale Price',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productSalePriceController.value=value;
                        addProductController.validateProductSalePriceInput();
                      },
                    )),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('Full Price',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productFullPriceErrorText.value,
                        hintText: 'Enter Full Price',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productFullPriceController.value=value;
                        addProductController.validateProductFullPriceInput();
                      },
                    )),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('Delivery Time',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productDeliveryTimeErrorText.value,
                        hintText: 'Enter Delivery Time',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productDeliveryTimeController.value=value;
                        addProductController.validateProductDeliveryTimeInput();
                      },
                    )),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10,left: 20),
                      child: Text('Product Description',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                    child:Obx(()=> TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: addProductController.productDescriptionErrorText.value,
                        hintText: 'Enter Product Description',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        filled: true,
                        fillColor: Colors.grey[250],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                          borderSide: BorderSide.none,             // optional: remove border line
                        ),
                      ),
                      onChanged: (value) {
                        addProductController.productDescriptionController.value=value;
                        addProductController.validateProductDescriptionInput();
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
                      controller: addProductController.dateTimeController,
                      readOnly: true,
                      onTap: ()=>addProductController.selectDateTime(context),
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
                      controller: addProductController.dateTimeController,
                      onTap: ()=>addProductController.selectDateTime(context),
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
        ),
      ),
      bottomSheet: CustomBottomBtn(title: 'Add', callback: ()async{

        bool isCategoryIdValid=addProductController.validateCategoryIdInput();
        bool isCategoryNameValid=addProductController.validateCategoryNameInput();
        bool isProductNameValid=addProductController.validateProductNameInput();
        bool isSaleValid=addProductController.validateProductIsSaleInput();
        bool isSalePriceValid=addProductController.validateProductSalePriceInput();
        bool isFullPriceValid=addProductController.validateProductFullPriceInput();
        bool isDeliveryTimeValid=addProductController.validateProductDeliveryTimeInput();
        bool isProductDescriptionValid=addProductController.validateProductDescriptionInput();

        List<String> images = addProductController.imageUrls;

        List<String> sizes = addProductController.productSizes;


        if(isCategoryIdValid && isCategoryNameValid &&  isProductNameValid &&
             isSaleValid && isSalePriceValid && isFullPriceValid &&
        isDeliveryTimeValid && isProductDescriptionValid){
          if(addProductController.productIdController.text.toString().isNotEmpty && addProductController.dateTimeController.text.toString().isNotEmpty
          && images.isNotEmpty && sizes.isNotEmpty){
            String isSaleInput = addProductController.productIsSaleController.value.trim().toLowerCase();
            bool? isSale;

            if (isSaleInput == 'true') {
              isSale = true;
            } else if (isSaleInput == 'false') {
              isSale = false;
            }
            try {
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(addProductController.productIdController.text.toString()) // Setting custom doc ID
                  .set({
                'categoryId': addProductController.categoryIdController.value.toString(),
                'categoryName': addProductController.categoryNameController.value.toString(),
                'productId': addProductController.productIdController.text.toString(),
                'productName': addProductController.productNameController.value.toString(),
                'productImages': images,
                'sizes': sizes,
                'isSale': isSale,
                'salePrice': addProductController.productSalePriceController.value.toString(),
                'fullPrice': addProductController.productFullPriceController.value.toString(),
                'deliveryTime': addProductController.productDeliveryTimeController.value.toString(),
                'productDescription': addProductController.productDescriptionController.value.toString(),
                'createdAt': addProductController.formatted,
                'updatedAt': addProductController.formatted,
              });
              Get.snackbar('Success', 'Product added with ID: ${addProductController.productIdController.text.toString()}',snackPosition: SnackPosition.BOTTOM);
              Get.offAll(()=>AdminMainScreen());
            } catch (e) {
              Get.snackbar('Error', 'Error adding product: $e',snackPosition: SnackPosition.BOTTOM);
            }          }else{
            Get.snackbar('Error', 'Please fill all details',snackPosition: SnackPosition.BOTTOM);
          }
        }else{
          Get.snackbar('Error', 'Please fill all details',snackPosition: SnackPosition.BOTTOM);
        }
      }),
    );
  }
}
