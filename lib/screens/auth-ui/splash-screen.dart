

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get-user-data-controller.dart';
import '../../utils/app-constant.dart';
import '../../widgets/bottombar-widget.dart';
import '../admin-panel/admin-dashboard-screen.dart';
import '../user-panel/main-screen.dart';
import 'welcome-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      loggdin(context);
     // Get.offAll(() => WelcomeScreen());
    });
  }
  Future<void> loggdin(BuildContext context) async{
    if(user!=null){
      final GetUserDataController getUserDataController= Get.put(GetUserDataController());
      var userData=await getUserDataController.getUserData(user!.uid);

      if(userData[0]['isAdmin'] == true){
        Get.offAll(()=>AdminDashboardScreen());

      }else{
        Get.offAll(()=>BottomBarWidget());
      }
    }else{
      Get.to(()=>WelcomeScreen());
    }
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Image.asset('assets/images/splashScreen.png')),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              AppConstant.appName,
              style: TextStyle(color: AppConstant.appTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
