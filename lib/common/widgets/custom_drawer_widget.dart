import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/screens/user-panel/all_order_screen.dart';
import 'package:ecom/screens/user-panel/all_products.dart';
import 'package:ecom/screens/user-panel/contact_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomDrawerWidget extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: Get.height/25),
            child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(user!.displayName.toString(),style: TextStyle(color: AppConstant.appTextColor),),
                subtitle: Text('Version 1.0.1',style: TextStyle(color: AppConstant.appTextColor),),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: AppConstant.appMainColor,
                  child: Text(user!.displayName.toString().substring(0,1),style: TextStyle(color: AppConstant.appTextColor),),
                ),
              ),
            ),
            Divider(indent: 10.0,
            endIndent: 10.0,
            thickness: 1.5,
            color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Home',style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.home,color: Colors.white,),
                trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                onTap: (){
                 Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Products',style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.production_quantity_limits,color: Colors.white,),
                trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                onTap: (){
                  Get.back();
                  Get.to(AllProducts());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Orders',style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.shopping_bag,color: Colors.white,),
                trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                onTap: (){
                  Get.back();
                  Get.to(AllOrderScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Contact',style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.help,color: Colors.white,),
                trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                onTap: (){
                  Get.back();
                  Get.to(ContactScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: InkWell(
                onTap: ()async{
                  GoogleSignIn googleSignIn=GoogleSignIn();
                  FirebaseAuth _auth=FirebaseAuth.instance;

                  await _auth.signOut();

                  await googleSignIn.signOut();
                  Get.offAll(()=>WelcomeScreen());
                },
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Logout',style: TextStyle(color: AppConstant.appTextColor),),
                  leading: Icon(Icons.logout,color: Colors.white,),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
              backgroundColor: AppConstant.appSecondaryColor,
    ),
    );
  }
}
