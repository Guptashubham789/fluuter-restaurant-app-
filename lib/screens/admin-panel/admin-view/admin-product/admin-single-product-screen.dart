import 'package:flutter/material.dart';
import 'package:guptaresturent/models/product-model.dart';
import 'package:guptaresturent/utils/app-constant.dart';

class AdminSingleProductScreen extends StatefulWidget {
  ProductModel productModel;
   AdminSingleProductScreen({super.key, required this.productModel});

  @override
  State<AdminSingleProductScreen> createState() => _AdminSingleProductScreenState();
}

class _AdminSingleProductScreenState extends State<AdminSingleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Product Detail'),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Product Name "),
                        Text(widget.productModel.productName,overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Product Price "),
                        Text(widget.productModel.fullPrice!=''?widget.productModel.fullPrice:widget.productModel.comboPrice,overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Delivery Time "),
                        Text(widget.productModel.deliveryTime,overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Is Sale "),
                        Text(widget.productModel.isComboSale?"True":"False",overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(widget.productModel.productImages[0],height: 200,width: 100,),
                        ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
