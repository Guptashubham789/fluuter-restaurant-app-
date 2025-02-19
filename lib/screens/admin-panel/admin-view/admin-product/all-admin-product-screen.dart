import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/screens/admin-panel/admin-view/admin-product/admin-single-product-screen.dart';

import '../../../../models/product-model.dart';
import '../../../../utils/app-constant.dart';
import 'admin-add-product-screen.dart';





class AllAdminProductScreen extends StatefulWidget {
  const AllAdminProductScreen({super.key});

  @override
  State<AllAdminProductScreen> createState() => _AllAdminProductScreenState();
}

class _AllAdminProductScreenState extends State<AllAdminProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Product'),
        backgroundColor: AppConstant.appMainColor,
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(()=>AdminAddProductScreen());
            },
            child: Padding(padding: EdgeInsets.all(10.0),
              child:Icon(Icons.add),
            ),
          ),

        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .orderBy('createdAt',descending: true)
              .snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Error occured while fetching product!!'),
              );
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Container(
                height: Get.height/5,
                child: Center(
                  child:CupertinoActivityIndicator(),
                ),
              );
            }

            //jo data fetch kar rhe hai kya vh empty to nhi hai agr empty h to center me
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: Text('No product found!!'),
              );
            }
            if(snapshot.data!=null){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
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
                    return Card(
                      elevation: 5,

                      child: ListTile(
                        onTap: (){
                          Get.to(()=>AdminSingleProductScreen(productModel:productModel));
                        },
                        title: Text(productModel.productName),
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage: NetworkImage(productModel.productImages[0]),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(productModel.productId,style: TextStyle(color: Colors.black,fontSize: 10.0),),
                            SizedBox(
                              width: Get.width/20.0,
                            ),

                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
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