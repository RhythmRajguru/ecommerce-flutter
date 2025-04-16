import 'package:app_settings/app_settings.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService{
  FirebaseMessaging messaging=FirebaseMessaging.instance;

      void requestNotificationPermission()async{
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      Get.snackbar('Success', 'user granted permission',snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor);
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      Get.snackbar('Success', 'user provisional granted permission',snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor);
    }else{
      Get.snackbar('Notification permission denied', 'Please allow notifications to receive updates.',snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor);
      Future.delayed(Duration(seconds: 2),(){
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }

      }
}