import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/models/cart-model.dart';
import 'package:guptaresturent/screens/user-panel/checkout-screen.dart';
import 'package:guptaresturent/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-total-price-controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  final ItemPriceController itemPriceController=Get.put(ItemPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Add to cart '),
      ),
       body:StreamBuilder(
         stream: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').snapshots(),
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
             return  Container(
               child: ListView.builder(

                 itemCount: snapshot.data!.docs.length,
                   itemBuilder: (context,index){
                     final data=snapshot.data!.docs[index];
                     CartModel cartModel=CartModel(
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
                       productQuantity: data['productQuantity'],
                       productTotalPrice: data['productTotalPrice'],
                     );
                     //calculate price
                     itemPriceController.fetchItemPrice();
                     return SwipeActionCell(
                         key: ObjectKey(cartModel.productId),
                         trailingActions: [
                           SwipeAction(
                             title: "Delete",
                               forceAlignmentToBoundary: true,
                               performsFirstActionWithFullSwipe: true,
                               onTap: (CompletionHandler handler) async{
                               await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                                Get.snackbar("Deleted", "remove items!!");
                           })
                         ],
                         child: Card(
                           elevation: 1,
                           child: ListTile(
                             leading: CircleAvatar(
                               backgroundColor: AppConstant.appSecondaryColor,
                               backgroundImage: NetworkImage(cartModel.productImages[0]),
                             ),
                             title: Text(cartModel.productName),
                             subtitle: Row(
                               children: [

                                 Text('INR : ${cartModel.isComboSale==true?cartModel.comboPrice:cartModel.fullPrice}'),
                                 SizedBox(width: 25,),
                                 Container(
                                   height: Get.height/30,
                                    width: Get.width/10,
                                   decoration: BoxDecoration(
                                       color:Colors.green,
                                       borderRadius: BorderRadius.circular(5.0)
                                   ),
                                   child: GestureDetector(
                                     onTap: () async{
                                       if(cartModel.productQuantity>1){
                                         await FirebaseFirestore.instance
                                             .collection('cart')
                                             .doc(user!.uid)
                                             .collection('cartOrders')
                                             .doc(cartModel.productId)
                                             .update({
                                              'productQuantity':cartModel.productQuantity-1,
                                           'productTotalPrice':(double.parse(cartModel.fullPrice)*(cartModel.productQuantity-1))
                                         });
                                       }
                                     },
                                     child: CircleAvatar(
                                       radius: 25,
                                       backgroundColor: Colors.green,
                                       child: Text('-'),
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 Text(cartModel.productQuantity.toString()),
                                 SizedBox(width: 10,),
                                 Container(
                                   height: Get.height/30,
                                   width: Get.width/10,
                                   decoration: BoxDecoration(
                                       color:Colors.green,
                                       borderRadius: BorderRadius.circular(5.0)
                                   ),
                                   child: GestureDetector(
                                     onTap: () async{
                                       if(cartModel.productQuantity>0){
                                         await FirebaseFirestore.instance
                                             .collection('cart')
                                             .doc(user!.uid)
                                             .collection('cartOrders')
                                             .doc(cartModel.productId)
                                             .update({
                                           'productQuantity':cartModel.productQuantity+1,
                                           'productTotalPrice':double.parse(cartModel.fullPrice)+double.parse(cartModel.fullPrice)*(cartModel.productQuantity)
                                         });
                                       }
                                     },
                                     child: CircleAvatar(
                                       radius: 25,
                                       backgroundColor: Colors.green,
                                       child: Text('+'),
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 IconButton(
                                     onPressed: () async{
                                       await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                                       Get.snackbar("Deleted", "remove items!!");
                                     }, icon: Icon(Icons.delete))
                               ],
                             ),
                           ),
                         ),
                     );
                   }),
             );

           }
           return Container();

         },
       ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:Obx(()=>Text(
                "Total : ${itemPriceController.totalPrice.value.toStringAsFixed(1)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,fontFamily: AppConstant.appFontFamily
                ),),)
            ),

            Padding(
              padding: const EdgeInsets.all( 18.0),
              child: Material(
                child: Container(
                  width: Get.width / 3.0,
                  height: Get.height / 18,

                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextButton(
                      child:  Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white,),
                      ),
                      onPressed: () {
                        Get.to(()=>CheckOutScreen());
                      },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

