import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/user-model.dart';
import '../../../utils/app-constant.dart';
import '../admin-controller/get-all-user-length-controller.dart';



class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final GetUserLengthController _getUserLengthController=Get.put(GetUserLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx((){
          return Text('User (${_getUserLengthController.userCollectionLength.toString()})');
        }),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('createdOn',descending: true)
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
                child: Text('No users found!!'),
              );
            }
            if(snapshot.data!=null){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    final data=snapshot.data!.docs[index];
                    Usermodel usermodel=Usermodel(
                      uId: data['uId'],
                      username: data['username'],
                      email: data['email'],
                      phone: data['phone'],
                      userImg:data['userImg'],
                      userDeviceToken: data['userDeviceToken'],
                      country: data['country'],
                      userAddress: data['userAddress'],
                      street: data['street'],
                      userCity: data['userCity'],
                      isAdmin: data['isAdmin'],
                      isActive: data['isActive'],
                      createdOn: data['createdOn'],
                    );
                    return Card(
                      elevation: 5,

                      child: ListTile(
                        title: Text(usermodel.username),
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage: NetworkImage(usermodel.userImg),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(usermodel.email,style: TextStyle(color: Colors.black,fontSize: 10.0),),
                            SizedBox(
                              width: Get.width/20.0,
                            ),

                          ],
                        ),
                        trailing: Icon(Icons.edit),
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