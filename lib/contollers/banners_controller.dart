import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:get/get.dart';

class BannersController extends GetxController{

  RxList<String> bannerUrls=RxList<String>([]);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchBannerUrls();
  }

  Future<void> fetchBannerUrls() async{
    try{
  QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('banners').get();

  if(querySnapshot.docs.isNotEmpty){
    bannerUrls.value=querySnapshot.docs.map((docs)=>docs['imageUrl'] as String).toList();
  }else{

  }

    }catch(e){
      Get.snackbar("Error", "$e",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
    }
  }
}