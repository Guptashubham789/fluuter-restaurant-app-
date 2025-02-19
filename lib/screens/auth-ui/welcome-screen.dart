import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/google-sign-in-controller.dart';
import '../../utils/app-constant.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GooglrSignInController googlrSignInController =
      Get.put(GooglrSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            'Welcome To Gupta Shop',
            style: TextStyle(fontFamily: AppConstant.appFontFamilyHeadung),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splashScreen.png'),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Happy Shopping!!!',
                      style: TextStyle(fontFamily: AppConstant.appFontFamily),
                    )),
                SizedBox(
                  height: Get.height / 10,
                ),
                Material(
                  child: Container(
                    width: Get.width / 1.1,
                    height: Get.height / 12,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextButton.icon(
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () {
                        googlrSignInController.signInWithGoogle();
                      },
                      icon: Image.asset(
                        'assets/images/google.png',
                        width: Get.width / 10,
                        height: Get.height / 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
              ],
            ),
          ),
        ));
  }
}
