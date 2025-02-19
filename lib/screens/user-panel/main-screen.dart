import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guptaresturent/screens/user-panel/all-combo-screen.dart';
import 'package:guptaresturent/screens/user-panel/all-items-screen.dart';
import 'package:guptaresturent/screens/user-panel/category-screen.dart';
import 'package:guptaresturent/widgets/combo-offer-widget.dart';
import 'package:guptaresturent/widgets/heading-widget.dart';

import '../../utils/app-constant.dart';
import '../../widgets/all-items-widget.dart';
import '../../widgets/banner-widget.dart';
import '../../widgets/category-widget.dart';
import '../auth-ui/welcome-screen.dart';
import 'cart-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appName,
        style: TextStyle(fontSize: 15),),
        actions: [

          IconButton(onPressed: (){
            //Get.to((AllComboScreen()));
            //Get.to((AllItemScreen()));
            Get.to(()=>CartScreen());
          }, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: Get.height/90.0,),
                BannerWidget(),
                HeadingWidget(headingTitle: 'Category', headingSubTitle: 'Our all items.. ', buttonText: ' ', onTap: () {

                  //Get.to(()=>CategoryScreen());

                },),
                CategoriesWidget(),
                HeadingWidget(headingTitle: 'Enjoy Your Welcome Offer!!', headingSubTitle: 'Flash Combo Offer..', buttonText: ' ', onTap: () {

                 // Get.to(()=>CategoryScreen());

                },),
                ComboOfferWidget(),
                HeadingWidget(
                  headingTitle: 'All Items!!', headingSubTitle: 'Here all items..', buttonText: ' ', onTap: () {

                  // Get.to(()=>CategoryScreen());

                },),
                AllItemWidget()
              ],
            ),
          ),
        ),
      )
    );
  }
}
