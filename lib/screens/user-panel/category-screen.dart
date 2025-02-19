import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

import '../../models/category-model.dart';
import '../../utils/app-constant.dart';
import 'single-category-items.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Menus'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('category').snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Categories is empty'),
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
                child: Text('No Category found!!'),
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
                    CategoriesModel categoriesModel=CategoriesModel(
                      categoryId: snapshot.data!.docs[index]['categoryId'],
                      categoryImg: snapshot.data!.docs[index]['categoryImg'],
                      categoryName: snapshot.data!.docs[index]['categoryName'],
                      createdAt: snapshot.data!.docs[index]['createdAt'],
                      updatedAt: snapshot.data!.docs[index]['updatedAt'],
                    );
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>SingleCategoryItems(categoryId:categoriesModel.categoryId,categoryName:categoriesModel.categoryName));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: FillImageCard(
                                borderRadius: 20.0,
                                width: Get.width/2.3,
                                heightImage: Get.height/7,
                                imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg),

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