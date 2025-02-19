import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/models/cart-model.dart';
import 'package:guptaresturent/screens/user-panel/checkout-screen.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-total-price-controller.dart';
import '../../models/order-model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  final ItemPriceController itemPriceController=Get.put(ItemPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Your Order '),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').doc(user!.uid).collection('ConfirmOrders').orderBy('createdAt',descending: true).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text('Error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
              height: Get.height/5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if(snapshot.data!.docs.isEmpty){
            return Center(
              child: Text('No order and order is empty..!'),
            );
          }
          if(snapshot.data!=null){
            return  Container(
              child: ListView.builder(

                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    final data=snapshot.data!.docs[index];
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
                      customerId: data['customerId'],
                      status: data['status'], //starting me false send karenge
                      customerName: data['customerName'],
                      customerPhone: data['customerPhone'],
                      customerNearBy: data['customerNearBy'],
                      customerAddress: data['customerAddress'],
                      customerDeviceToken: data['customerDeviceToken'],
                    );

                    return Card(
                      elevation: 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appSecondaryColor,
                          backgroundImage: NetworkImage(orderModel.productImages[0]),
                        ),
                        title: Text(orderModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('INR : ${orderModel.isComboSale==true?orderModel.comboPrice:orderModel.fullPrice}'),
                            Container(
                                height: Get.height/30,
                                width: Get.width/2.5,
                                decoration: BoxDecoration(
                                    color: AppConstant.appMainColor,
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                child:Center(child:  orderModel.status!=true?Center(child: Text('Order Confirmed',style: TextStyle(color: Colors.red,fontSize: 13,fontFamily: AppConstant.appFontFamilyHeadung),)):Text("Delivered",style: TextStyle(color: Colors.green,fontSize: 13,fontFamily: AppConstant.appFontFamilyHeadung)))
                            ),


                          ],
                        ),
                      ),
                    );
                  }),
            );

          }
          return Container();

        },
      ),


    );
  }
}

