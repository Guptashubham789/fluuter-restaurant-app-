import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptaresturent/models/product-model.dart';
import 'package:image_card/image_card.dart';

import '../../models/category-model.dart';
import '../../utils/app-constant.dart';
import 'items-detail-screen.dart';

class SingleCategoryItems extends StatefulWidget {
  String categoryId;
  String categoryName;
   SingleCategoryItems({super.key, required this.categoryId, required this.categoryName});

  @override
  State<SingleCategoryItems> createState() => _SingleCategoryItemsState();
}

class _SingleCategoryItemsState extends State<SingleCategoryItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(widget.categoryName),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').where('categoryId',isEqualTo: widget.categoryId).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('items is empty'),
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
                child: Text('No items found!!'),
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
                        onTap: ()=>Get.to(()=>ItemsDetailScreen(productModel:productModel)),
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
                            SizedBox(height: 10,),
                            Container(
                                height: Get.height/24,
                                width: Get.width/4,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                child:
                                productModel.isComboSale==true && productModel.isComboSale!=''?Center(child: Text("INR : "+productModel.comboPrice+" -/",style: TextStyle(color: Colors.white),)):Center(child: Text("INR : "+productModel.fullPrice+" -/",style: TextStyle(color: Colors.white),),)

                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("⭐️⭐️⭐️ 4.8"),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border))
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
          }
      ),
    );
  }
}