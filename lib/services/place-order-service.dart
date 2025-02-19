import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import 'package:guptaresturent/services/genrate-order-id-service.dart';

import '../models/order-model.dart';
import '../utils/app-constant.dart';
import '../widgets/bottombar-widget.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerNearBy,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async{
  final user=FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please wait!!");
  if(user!=null){
    try{
      QuerySnapshot querySnapshot=await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .get();

        List<QueryDocumentSnapshot> documents=querySnapshot.docs;

        for(var doc in documents){
          Map<String,dynamic>? data=doc.data() as Map<String,dynamic>;

          String orderId=genrateOrderId();
          OrderModel orderModel=OrderModel(
            productId: data['productId'],
            categoryId: data['categoryId'],
            productName: data['productName'],
            categoryName: data['categoryName'],
            comboPrice: data['comboPrice'],
            fullPrice: data['fullPrice'],
            productImages: data['productImages'],
            deliveryTime: data['deliveryTime'],
            isComboSale: data['isComboSale'],
            productDescription: data['productDescription'],
            createdAt:DateTime.now(),
            updatedAt: data['updatedAt'],
            productQuantity: data['productQuantity'],
            productTotalPrice: data['productTotalPrice'],
            customerId: user.uid,
            status: false, //starting me false send karenge
            customerName: customerName,
            customerPhone: customerPhone,
            customerNearBy: customerNearBy,
            customerAddress: customerAddress,
            customerDeviceToken: customerDeviceToken,
          );
          for(var x=0; x<documents.length;x++){
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(user.uid)
                .set({
              'uId':user.uid,
              'customerName':customerName,
              'customerPhone':customerPhone,
              'customerAddress':customerAddress,
              'customerDeviceToken':customerDeviceToken,
              'orderStatus':false,
              'createdAt':DateTime.now()
            },
            );
            //upload Orders
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(user.uid)
                .collection('ConfirmOrders')
                .doc(orderId)
                .set(orderModel.toMap());

            //delete cart product
            await FirebaseFirestore.instance
                .collection('cart')
                .doc(user.uid)
                .collection('cartOrders')
                .doc(orderModel.productId.toString())
                .delete().then((value){
              print("Delete cart product");
            });
          }
        }
      print("Order Confirmed");
      Get.snackbar("Order Confirmed", "Thank You for your order!!",
        snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
        duration: Duration(seconds: 5),
      );
      EasyLoading.dismiss();
      Get.offAll(()=>BottomBarWidget());

    }catch(e){
      Get.snackbar("Error", "your order is not confirmed..!!",
        snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
        duration: Duration(seconds: 5),
      );
    }


    }
}
