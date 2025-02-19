import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:guptaresturent/widgets/bottombar-widget.dart';

import 'admin-widget/admin-drawer-widget.dart';
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(onPressed: (){
            Get.offAll(()=>BottomBarWidget());
          }, icon: Icon(Icons.logout))
        ],
      ),
      drawer: AdminDrawerWidget(),
      body: Text("Admin Dashboard Screen"),
    );
  }
}
