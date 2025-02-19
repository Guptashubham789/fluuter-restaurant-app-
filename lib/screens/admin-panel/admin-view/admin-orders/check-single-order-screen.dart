import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/models/order-model.dart';
import 'package:guptaresturent/utils/app-constant.dart';

class CheckSingleOrderScreen extends StatefulWidget {
  String docId;
  OrderModel orderModel;
   CheckSingleOrderScreen({super.key, required  this.docId, required  this.orderModel});

  @override
  State<CheckSingleOrderScreen> createState() => _CheckSingleOrderScreenState();
}

class _CheckSingleOrderScreenState extends State<CheckSingleOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(widget.orderModel.productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider(
                items: widget.orderModel.productImages
                    .map(
                      (img) => ClipRRect(
                    borderRadius:BorderRadius.circular(5.0),

                    child: CachedNetworkImage(

                      imageUrl: img,
                      fit: BoxFit.cover,
                      width: Get.width-10,

                      placeholder: (context,url)=>ColoredBox(
                        color: Colors.white,
                        child:Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: (context,url,error)=>Icon(Icons.error),
                    ),
                  ),
                ).toList(),
                options: CarouselOptions(
                    height: 200,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                    aspectRatio: 2.5,
                    viewportFraction: 1
                ),
              ),
            ),
            SizedBox(height: 5,),
            Center(child: Text(widget.orderModel.productName,style: TextStyle(fontFamily: AppConstant.appFontFamilyHeadung,fontSize: 20.0),)),

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: Get.height/24,
                      width: Get.width/1.2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Coustomer Name : ${widget.orderModel.customerName}',style: TextStyle(color: Colors.white),))
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: Get.height/24,
                      width: Get.width/1.2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Coustomer Phone : ${widget.orderModel.customerPhone}',style: TextStyle(color: Colors.white),))
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: Get.height/24,
                      width: Get.width/1.2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Coustomer NearBy : ${widget.orderModel.customerNearBy}',style: TextStyle(color: Colors.white),))
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: Get.height/15,
                      width: Get.width/1.2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Coustomer Add : ${widget.orderModel.customerAddress}',style: TextStyle(color: Colors.white),))
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: Get.height/24,
                      width: Get.width/2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Total Quantity : ${widget.orderModel.productQuantity}'))
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: Get.height/24,
                      width: Get.width/2,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Center(child: Text('Total Price : ${widget.orderModel.productTotalPrice}'))
                  ),

                ],
              ),

            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text("Description - ",style: TextStyle(fontSize: 16,fontFamily: AppConstant.appFontFamilyHeadung),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 10.0),
              child: Text(widget.orderModel.productDescription,style: TextStyle(fontSize: 12,)),
            ),
            SizedBox(height: 5,),

          ],
        ),
      ),
    );
  }
}
