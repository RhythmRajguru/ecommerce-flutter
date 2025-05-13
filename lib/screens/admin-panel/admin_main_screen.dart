import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/widgets/custom_admin_drawer_widget.dart';
import '../../contollers/add_product_controller.dart';

class AdminMainScreen extends StatefulWidget {

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  AddProductController addProductController=Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      drawer: CustomAdminDrawerWidget(),
    );
  }

}
