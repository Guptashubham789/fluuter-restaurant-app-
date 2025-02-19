import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guptaresturent/utils/app-constant.dart';

import '../../../../models/order-model.dart';
import 'check-single-order-screen.dart';

class SpecificUserOrdersScreen extends StatefulWidget {
  String docId,customerName;
   SpecificUserOrdersScreen({super.key, required this.docId, required this.customerName});

  @override
  State<SpecificUserOrdersScreen> createState() => _SpecificUserOrdersScreenState();
}

class _SpecificUserOrdersScreenState extends State<SpecificUserOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(widget.customerName.toString()),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.docId)
              .collection('ConfirmOrders')
          .orderBy('createdAt',descending: true)
              .snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Error occured while fetching category!!'),
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
                child: Text('No order found!!'),
              );
            }
            if(snapshot.data!=null){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    final data=snapshot.data!.docs[index];
                    String orderDocId=data.id;
                    OrderModel orderModel=OrderModel(
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
                      createdAt:DateTime.now(),
                      updatedAt: data['updatedAt'],
                      productQuantity: data['productQuantity'],
                      productTotalPrice: data['productTotalPrice'],
                      customerId: data['customerId'],
                      status: data['status'], //starting me false send karenge
                      customerName: data['customerName'],
                      customerPhone: data['customerPhone'],
                      customerNearBy: data['customerNearBy'],
                      customerAddress: data['customerAddress'],
                      customerDeviceToken: data['customerDeviceToken'],
                    );
                    return Card(
                      elevation: 5,

                      child: ListTile(
                        onTap: (){
                          Get.to(()=>CheckSingleOrderScreen(
                            docId:snapshot.data!.docs[index].id,
                            orderModel:orderModel,
                          ));
                        },
                        title: Text(orderModel.productName),
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage: NetworkImage(orderModel.productImages[0]),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(orderModel.productQuantity.toString(),style: TextStyle(color: Colors.black,fontSize: 10.0),),
                            SizedBox(
                              width: Get.width/20.0,
                            ),
                            orderModel.status==true?Text('Delivered',style: TextStyle(color: Colors.green,fontSize: 13.0)):Text('Pending',style: TextStyle(color: Colors.red,fontSize: 13.0),),

                          ],
                        ),
                        trailing: InkWell(
                            onTap: (){
                              showBootomSheet(
                                userDocId:widget.docId,
                                orderDocId:orderDocId,
                                orderModel:orderModel,
                              );
                            },
                            child: Icon(Icons.more_vert)),
                      ),
                    );
                  });
            }
            return Container();
          }),
    );
  }
  void showBootomSheet({
    required String userDocId,
    required String orderDocId,
    required OrderModel orderModel,
  }){
    Get.bottomSheet(
        Container(
          height: Get.height/2,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        await FirebaseFirestore.instance.collection('orders').doc(userDocId).collection('ConfirmOrders').doc(orderDocId).update(
                            {
                              'status':false,
                            });
                      },
                      child: Text('Pending')
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        await FirebaseFirestore.instance.collection('orders').doc(userDocId).collection('ConfirmOrders').doc(orderDocId).update(
                            {
                              'status':true,
                            });

                      },
                      child: Text('Deliverd')
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        await FirebaseFirestore.instance.collection('orders').doc(userDocId).collection('ConfirmOrders').doc(orderDocId).delete();

                      },
                      child: Text('Delete')
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
