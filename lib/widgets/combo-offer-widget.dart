import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptaresturent/models/category-model.dart';
import 'package:guptaresturent/models/product-model.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/items-detail-screen.dart';

class ComboOfferWidget extends StatefulWidget {
  const ComboOfferWidget({super.key});

  @override
  State<ComboOfferWidget> createState() => _ComboOfferWidgetState();
}

class _ComboOfferWidgetState extends State<ComboOfferWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isComboSale',isEqualTo: true).get(),
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
          return Container(
            height: Get.height/4.0,
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  final data=snapshot.data!.docs[index];
                  ProductModel productModel=ProductModel(
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
                  );

                  return Row(

                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>ItemsDetailScreen(productModel:productModel));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(

                              child: TransparentImageCard(
                                width: Get.width/2.0,
                                height: Get.height/3.5,
                                imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),

                                title:Text(productModel.productName,style: TextStyle(color:Colors.white),),
                                footer: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rs- ${productModel.comboPrice}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Text(
                                      "Rs- ${productModel.fullPrice}",
                                      style: TextStyle(color: Colors.white,decoration: TextDecoration.lineThrough),
                                    )
                                  ],
                                ),

                              ),

                              ),
                        ),
                      ),

                      
                    ],
                  );
                }),
          );
        }
        return Container();

      },
    );
  }
}
