import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptaresturent/models/category-model.dart';
import 'package:guptaresturent/screens/user-panel/single-category-items.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('category').get(),
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
              child: Text('No category found!'),
            );
          }
          if(snapshot.data!=null){
            return Container(
              //color: Colors.red,
              height: Get.height/6.0,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                  final data=snapshot.data!.docs[index];
                    CategoriesModel categoriesModel=CategoriesModel(
                        categoryId: data['categoryId'],
                        categoryImg: data['categoryImg'],
                        categoryName: data['categoryName'],
                        createdAt: data['createdAt'],
                        updatedAt: data['updatedAt'],
                    );
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>SingleCategoryItems(categoryId: categoriesModel.categoryId, categoryName: categoriesModel.categoryName,));
                          },
                          child: Padding(padding: EdgeInsets.all(5.0),
                          child:Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width/3.0,
                              heightImage:Get.height/8,
                              imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg),


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
