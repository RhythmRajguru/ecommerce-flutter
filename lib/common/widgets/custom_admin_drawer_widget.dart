import 'package:ecom/contollers/theme_controller.dart';
import 'package:ecom/screens/admin-panel/add_category_screen.dart';
import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/screens/user-panel/all_flash_sale_product.dart';
import 'package:ecom/screens/user-panel/all_order_screen.dart';
import 'package:ecom/screens/user-panel/all_products.dart';
import 'package:ecom/screens/user-panel/contact_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/screens/user-panel/profile_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomAdminDrawerWidget extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;
  ThemeController themeController=Get.put(ThemeController());
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,

                title: (user!.displayName !=null && user!.displayName.toString().isNotEmpty)
                    ?Text(user!.displayName.toString(),style: TextStyle(),)
                    :Text(user!.email.toString(),style: TextStyle(),),

                subtitle: Text('Version 1.0.1',style: TextStyle(),),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: AppConstant.appMainColor,

                  child: (user!.photoURL!=null && user!.photoURL.toString().isNotEmpty)
                      ?Image.network(user!.photoURL.toString(),fit: BoxFit.cover)
                      :Text(user!.email.toString().substring(0,1).toUpperCase(),style: TextStyle(),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Dark Mode',style: TextStyle(),),
                leading: Icon(Icons.sunny),
                trailing: Obx(()=>CupertinoSwitch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) {
                    themeController.toggleTheme(value);
                  },),),
                onTap: (){
                  Get.to(ProfileScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(indent: 10.0,
                endIndent: 10.0,
                thickness: 1.5,
                color: Colors.grey,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Home',style: TextStyle(),),
                leading: Icon(Icons.home,),

                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Profile',style: TextStyle(),),
                leading: Icon(Icons.person_search_rounded,),

                onTap: (){
                  Get.to(ProfileScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Add Category',style: TextStyle(),),
                leading: Icon(Icons.category),

                onTap: (){
                  Get.back();
                  Get.to(AddCategoryScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Add Product',style: TextStyle(),),
                leading: Icon(Icons.add_shopping_cart),

                onTap: (){
                  Get.back();
                  Get.to(MainScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0),
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
                  title: Text('Logout',style: TextStyle(color: Colors.red),),
                  leading: Icon(Icons.logout,color: Colors.red,),

                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
