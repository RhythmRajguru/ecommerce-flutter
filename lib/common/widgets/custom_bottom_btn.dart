import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomBtn extends StatelessWidget {
  String title;
  VoidCallback callback;

  CustomBottomBtn({required this.title,required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: callback,
        child: Container(
          height: 60,
          width: double.infinity,
          color: AppConstant.appMainColor,
          child: Center(child: Text(title,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'Inter'),)),
        ),
      ),
    );
  }
}
