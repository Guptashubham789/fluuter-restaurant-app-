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

class AllItemWidget extends StatefulWidget {
  const AllItemWidget({super.key});

  @override
  State<AllItemWidget> createState() => _AllItemWidgetState();
}

class _AllItemWidgetState extends State<AllItemWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isComboSale',isEqualTo: false).get(),
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
          return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.7

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
                return  Container(
                  height: Get.height/3.5,
                  width: Get.width/2,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: GestureDetector(
                    onTap: (){
                     Get.to(()=>ItemsDetailScreen(productModel:productModel));
                    },
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width/3.0,
                            heightImage:Get.height/9,
                            imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),


                          ),

                        ),
                        Text(productModel.productName,style: TextStyle(fontFamily: AppConstant.appFontFamilyHeadung,fontSize: 16.0),),
                        Text('Rs- ${productModel.fullPrice}'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: Get.height/20,
                                  width: Get.width/6,
                                decoration: BoxDecoration(
                                  color:Colors.green,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                  child:  Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.add),color: Colors.white,)),
                                  ),
                              Container(

                                  child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border)))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

          );
        }
        return Container();

      },
    );
  }
}
