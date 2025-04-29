import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController{

  User? user=FirebaseAuth.instance.currentUser;
  ProductModel productModel;
  RxBool isFavourite=false.obs;
  FavouriteController({required this.productModel});

  //add favourite product
  Future<void> addFavouriteProduct()async{
    if(isFavourite.value==false){
      await FirebaseFirestore.instance.collection('products').doc(
          user!.uid).
      collection('favourite').doc(productModel.productId).set(
          productModel.toMap());

      Get.snackbar('Success', 'Product added to wishlist',
          snackPosition: SnackPosition.BOTTOM,
          );

        isFavourite.value=true;

    }else if(isFavourite.value!=false){
      await FirebaseFirestore.instance.collection('products').doc(
          user!.uid).
      collection('favourite').doc(productModel.productId).delete();

      Get.snackbar('Success', 'Product removed from wishlist',
          snackPosition: SnackPosition.BOTTOM,
         );

        isFavourite.value=false;

    }
  }




}
