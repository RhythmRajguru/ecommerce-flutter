import 'package:ecom/screens/auth-ui/welcome_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppConstant.appMainColor,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/gender_screen_illustrator.png'),
              fit: BoxFit.cover
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.all(10),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Look Good, Feel good',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create your individual & unique style and',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Inter'),),
                          Text('look amazing everyday.',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Inter'),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.offAll(()=>WelcomeScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 60,
                              width: 130,
                              child: Center(child: Text('Men',style: TextStyle(color: Colors.white,fontFamily: 'Inter'),)),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.offAll(()=>WelcomeScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppConstant.appMainColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 60,
                              width: 130,
                              child: Center(child: Text('Women',style: TextStyle(color: Colors.white,fontFamily: 'Inter'),)),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Get.offAll(()=>WelcomeScreen());
                        },
                          child: Text('Skip',style: TextStyle(decoration: TextDecoration.underline,color: Colors.grey,fontFamily: 'Inter'),)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
