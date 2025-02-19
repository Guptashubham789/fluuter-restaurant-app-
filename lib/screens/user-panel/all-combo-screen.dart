import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';


import '../../models/category-model.dart';
import '../../models/product-model.dart';
import '../../utils/app-constant.dart';
import 'items-detail-screen.dart';

class AllComboScreen extends StatefulWidget {
  const AllComboScreen({super.key});

  @override
  State<AllComboScreen> createState() => _AllComboScreenState();
}

class _AllComboScreenState extends State<AllComboScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Flash Combo Offer..'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').where('isComboSale',isEqualTo: true).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Items is empty'),
              );
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Container(
                height: Get.height/5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            //jo data fetch kar rhe hai kya vh empty to nhi hai agr empty h to center me
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: Text('No Items found!!'),
              );
            }
            if(snapshot.data!=null){
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1.19

                  ),
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
                            onTap: ()=>Get.to(()=>ItemsDetailScreen(productModel:productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: FillImageCard(
                                borderRadius: 20.0,
                                width: Get.width/2.3,
                                heightImage: Get.height/7,
                                imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),

                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }

              );
            }
            return Container();
          }
      ),
    );
  }
}
