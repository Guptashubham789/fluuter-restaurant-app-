import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptaresturent/models/cart-model.dart';
import 'package:guptaresturent/models/product-model.dart';

import '../../utils/app-constant.dart';

class ItemsDetailScreen extends StatefulWidget {
  ProductModel productModel;
   ItemsDetailScreen({super.key, required this.productModel});

  @override
  State<ItemsDetailScreen> createState() => _ItemsDetailScreenState();
}

class _ItemsDetailScreenState extends State<ItemsDetailScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: Get.height/1,
            width: Get.width/1,
            decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider(
                    items: widget.productModel.productImages
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
                        height: 300,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        aspectRatio: 2.5,
                        viewportFraction: 1
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Center(child: Text(widget.productModel.productName,style: TextStyle(fontFamily: AppConstant.appFontFamilyHeadung,fontSize: 20.0),)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(" ⭐️ 4.8"),
                      Text(widget.productModel.deliveryTime)
                    ],
                  ),
        
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: Get.height/24,
                        width: Get.width/4,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child:
                            widget.productModel.isComboSale==true && widget.productModel.isComboSale!=''?Center(child: Text("INR : "+widget.productModel.comboPrice+" -/",style: TextStyle(color: Colors.white),)):Center(child: Text("INR : "+widget.productModel.fullPrice+" -/",style: TextStyle(color: Colors.white),),)

                      ),
                      Icon(Icons.share),
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
                  child: Text(widget.productModel.productDescription,style: TextStyle(fontSize: 12,)),
                ),
                SizedBox(height: 5,),
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextButton.icon(
                            label: Text(
                              'Add to cart',
                              style: TextStyle(color: Colors.white,),
                            ),
                            onPressed: () async{
                              await checkItemsExistence(uId:user!.uid);
                            },
                            icon: Icon(Icons.add,color: Colors.white,)
                          ),
                        ),
                      ),
                      Material(
                        child: Container(
                          width: Get.width / 2.5,
                          height: Get.height / 15,
                          decoration: BoxDecoration(
                              color: AppConstant.appSecondaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextButton.icon(
                              label: Text(
                                'Whichlist',
                                style: TextStyle(color: AppConstant.appTextColor),
                              ),
                              onPressed: () {
                              },
                              icon: Icon(Icons.favorite_border_outlined)
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  //check product exist or not
  Future<void> checkItemsExistence({required String uId,int quantityIncrement=1,}) async{

  final DocumentReference documentReference=FirebaseFirestore.instance
      .collection('cart')
      .doc(uId)
      .collection('cartOrders')
      .doc(widget.productModel.productId.toString());

  DocumentSnapshot snapshot=await documentReference.get();

  if(snapshot.exists){
    int currentQuantity=snapshot['productQuantity'];
    int updatedQuantity=currentQuantity+quantityIncrement;
    double totalPrice=double.parse(widget.productModel.isComboSale?widget.productModel.comboPrice:widget.productModel.fullPrice)*updatedQuantity;

    await documentReference.update({
      'productQuantity':updatedQuantity,
      'productTotalPrice':totalPrice
    });
    Get.snackbar('Item', 'Item is already exist in cart screen!!');
  }else{
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .set({
      'uId':uId,
      'createdAt':DateTime.now(),
    }
    );
    CartModel cartModel=CartModel(
        productId:widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
      comboPrice: widget.productModel.comboPrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
      isComboSale: widget.productModel.isComboSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity:1,
        productTotalPrice:double.parse(widget.productModel.isComboSale?widget.productModel.comboPrice:widget.productModel.fullPrice),
    );
    await documentReference.set(cartModel.toMap());
    Get.snackbar('Item', 'item is added in cart screen..!!');
  }

  }
}
