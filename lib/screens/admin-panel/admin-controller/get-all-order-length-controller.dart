import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetOrderLengthController  extends GetxController{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot<Map<String,dynamic>>> _userControllerSubscription;

  final Rx<int> orderCollectionLength=Rx<int>(0);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _userControllerSubscription= _firestore.collection('orders').snapshots().listen((snapshot){
      orderCollectionLength.value=snapshot.size;
    });
  }
  @override
  void onClose() {
    // TODO: implement onClose
    _userControllerSubscription.cancel();
    super.onClose();
  }
}