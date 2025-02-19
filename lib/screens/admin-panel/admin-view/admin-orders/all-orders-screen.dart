import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app-constant.dart';
import '../../admin-controller/get-all-order-length-controller.dart';
import '../../admin-controller/get-all-user-length-controller.dart';
import 'SpecificUserOrderScreen.dart';

class AllUserOrderScreen extends StatefulWidget {
  const AllUserOrderScreen({super.key});

  @override
  State<AllUserOrderScreen> createState() => _AllUserOrderScreenState();
}

class _AllUserOrderScreenState extends State<AllUserOrderScreen> {
  final GetOrderLengthController _getOrderLengthController=Get.put(GetOrderLengthController());
  User? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Obx((){
          return Text('User (${_getOrderLengthController.orderCollectionLength.toString()})');
        }),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt',descending: true).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Error occured while fetching orders!!'),
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
                child: Text('No orders found!!'),
              );
            }

            if(snapshot.data!=null){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    final data=snapshot.data!.docs[index];

                    return Card(
                      elevation: 5,

                      child: ListTile(
                        onTap: (){
                          Get.to(()=>SpecificUserOrdersScreen(
                              docId:snapshot.data!.docs[index]['uId'],
                              customerName:snapshot.data!.docs[index]['customerName']
                          ));
                        },
                        title: Text(data['customerName']),
                        leading: CircleAvatar(
                          child: Text(data['customerName'][0]),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(data['customerPhone'],style: TextStyle(color: Colors.black,fontSize: 10.0),),
                            SizedBox(
                              width: Get.width/20.0,
                            ),

                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    );
                  }

              );
            }
            return Container();
          }),
    );
  }
}
