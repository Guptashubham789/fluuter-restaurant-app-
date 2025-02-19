import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/controllers/get-customer-device-token-controller.dart';
import 'package:guptaresturent/models/cart-model.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-total-price-controller.dart';
import '../../services/place-order-service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  final ItemPriceController itemPriceController=Get.put(ItemPriceController());
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController nearByController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('CheckOut Screen  '),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').snapshots(),
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
              child: Text('No combo offer found!'),
            );
          }
          if(snapshot.data!=null){
            return  Container(
              child: ListView.builder(

                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    final data=snapshot.data!.docs[index];
                    CartModel cartModel=CartModel(
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
                      createdAt: data['createdAt'],
                      updatedAt: data['updatedAt'],
                      productQuantity: data['productQuantity'],
                      productTotalPrice: data['productTotalPrice'],
                    );
                    //calculate price
                    itemPriceController.fetchItemPrice();
                    return SwipeActionCell(
                      key: ObjectKey(cartModel.productId),
                      trailingActions: [
                        SwipeAction(
                            title: "Delete",
                            forceAlignmentToBoundary: true,
                            performsFirstActionWithFullSwipe: true,
                            onTap: (CompletionHandler handler) async{
                              await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                              Get.snackbar("Deleted", "remove items!!");
                            })
                      ],
                      child: Card(
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appSecondaryColor,
                            backgroundImage: NetworkImage(cartModel.productImages[0]),
                          ),
                          title: Text(cartModel.productName),
                          subtitle: Row(
                            children: [

                              Text('INR : ${cartModel.isComboSale==true?cartModel.comboPrice:cartModel.fullPrice}'),
                              SizedBox(width: 25,),

                              SizedBox(width: 10,),

                             ],
                          ),
                        ),
                      ),
                    );
                  }),
            );

          }
          return Container();

        },
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child:Obx(()=>Text(
                  "Total : ${itemPriceController.totalPrice.value.toStringAsFixed(1)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,fontFamily: AppConstant.appFontFamily
                  ),),)
            ),

            Padding(
              padding: const EdgeInsets.all( 18.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.5,
                  height: Get.height / 18,

                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextButton(
                    child:  Text(
                      'Confirm Order',
                      style: TextStyle(color: Colors.white,),
                    ),
                    onPressed: () {
                        showCustomBottomSheet();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showCustomBottomSheet(){
    Get.bottomSheet(
      Container(
        height:Get.height/0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0),),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name ',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Phone ',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: nearByController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Near by ',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Address  ',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all( 10.0),
                child: Material(
                  child: Container(
                    width: Get.width / 2.0,
                    height: Get.height / 18,

                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextButton(
                      child:  Text(
                        'Place Order',
                        style: TextStyle(color: Colors.white,),
                      ),
                      onPressed: () async{
                        if(nameController.text!= '' && phoneController.text!= '' && nearByController.text!='' && addressController.text!=''){
                          String name=nameController.text.trim();
                          String phone=phoneController.text.trim();
                          String nearBy=nearByController.text.trim();
                          String address=addressController.text.trim();
                          String customerToken= await getCustomerDeviceToken();
                          //place order service
                          placeOrder(
                            context:context,
                            customerName:name,
                            customerPhone:phone,
                            customerNearBy:nearBy,
                            customerAddress:address,
                            customerDeviceToken:customerToken,
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all details.."),
                              duration: Duration(seconds: 3), // Duration the message is displayed
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}

