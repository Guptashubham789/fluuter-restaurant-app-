import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/utils/app-constant.dart';

import '../../admin-controller/product-images-controller.dart';

class AdminAddProductScreen extends StatefulWidget {
   AdminAddProductScreen({super.key});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  AddProductImagesController addProductImagesController=Get.put(AddProductImagesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Add Product '),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Images'),
                  ElevatedButton(
                      onPressed: (){
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: Text('Select Images')
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
