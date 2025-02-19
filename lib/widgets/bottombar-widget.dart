import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:guptaresturent/screens/user-panel/order-screen.dart';
import 'package:guptaresturent/utils/app-constant.dart';

import '../screens/user-panel/cart-screen.dart';
import '../screens/user-panel/category-screen.dart';
import '../screens/user-panel/main-screen.dart';
import '../screens/user-panel/profile-screen.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  late List<Widget> pages;
  late MainScreen mainScreen;
  late CategoryScreen categoryScreen;
  late CartScreen cartScreen;
  late ProfileScreen profileScreen;
  int currentTabIndex=0;

  @override
  void initState() {
    mainScreen=MainScreen();
    categoryScreen=CategoryScreen();
    cartScreen=CartScreen();
    profileScreen=ProfileScreen();
    pages=[mainScreen,categoryScreen,cartScreen,profileScreen];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        color: AppConstant.appMainColor,
        animationDuration: Duration(milliseconds: 400),
        onTap: (int index){
          setState(() {
            currentTabIndex=index;
          });
        },
        items: [
        Icon(
          Icons.home,
          color: Colors.black,
          size: 30.0,
        ),
          Icon(Icons.dashboard,color: Colors.black,size: 30.0,),
          Icon(Icons.shopping_cart,color: Colors.black,size: 30.0,),
          Icon(Icons.list,color: Colors.black,size: 30.0,),

      ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
