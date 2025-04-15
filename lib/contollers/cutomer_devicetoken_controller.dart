import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


  Future<String> getCustomerDeviceToken()async{
    try{
      String? token=await FirebaseMessaging.instance.getToken();
      if(token!=null){
        return token;
      }else{
        throw Exception('Error');
      }
    }catch(e){
      print('error $e');
      throw Exception('Error');
    }
  }
