import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guptaresturent/screens/admin-panel/admin-dashboard-screen.dart';
import 'package:guptaresturent/screens/auth-ui/splash-screen.dart';
import 'package:guptaresturent/screens/user-panel/order-screen.dart';

import '../../controllers/google-sign-in-controller.dart';
import '../../utils/app-constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  final GooglrSignInController googlrSignInController =
  Get.put(GooglrSignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello!! ",style: TextStyle(fontSize: 25.0,fontFamily: 'serif'),),
                  CircleAvatar(
                    backgroundImage:NetworkImage(user!.photoURL.toString()),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(user!.displayName.toString(),style: TextStyle(fontSize: 25.0,color: Colors.red,fontFamily: 'cursive'),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(user!.email.toString(),style: TextStyle(fontSize: 15.0,fontFamily: 'sens'),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    child: Container(
                      width: Get.width / 2.5,
                      height: Get.height / 15,

                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextButton.icon(
                          label: Text(
                            'My Order',
                            style: TextStyle(color: Colors.white,),
                          ),
                          onPressed: () async{
                              Get.to(()=>OrderScreen());
                          },
                          icon: Icon(Icons.shopping_bag_outlined,color: Colors.white,)
                      ),
                    ),
                  ),
                  Material(
                    child: Container(
                      width: Get.width / 2.5,
                      height: Get.height / 15,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextButton.icon(
                          label: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async{
                            GoogleSignIn googleSignIn=GoogleSignIn();
                            FirebaseAuth _auth=FirebaseAuth.instance;
                            await _auth.signOut();
                            await googleSignIn.signOut();
                            Get.offAll(()=>SplashScreen());
                          },
                          onLongPress: (){
                            Get.to(()=>AdminDashboardScreen());
                          },
                          icon: Icon(Icons.logout,color: Colors.white,)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
