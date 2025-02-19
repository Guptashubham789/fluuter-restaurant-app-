import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductImagesController extends GetxController{

  final ImagePicker _picker=ImagePicker();
  RxList<XFile> selectedImages=<XFile>[].obs;
  final RxList<String> arrImageUrl=<String>[].obs;
  final FirebaseStorage storageRef=FirebaseStorage.instance;

  Future<void> showImagesPickerDialog() async{
    PermissionStatus status;
    DeviceInfoPlugin deviceInfoPlugin=DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo=await deviceInfoPlugin.androidInfo;
    //ab hum version ko check karenge
    if(androidDeviceInfo.version.sdkInt<=32){
      status=await Permission.storage.request();
    }else{
      status=await Permission.mediaLibrary.request();
    }
    //ab hme check karna user ne hme allow kiya hai ya nhi
    if(status==PermissionStatus.granted){
      Get.defaultDialog(
        title: "Choose Image",
        middleText: "Pick an Image from the camera or gallery?",
        actions: [
          ElevatedButton(onPressed: (){}, child: Text('Cameara')),
          ElevatedButton(onPressed: (){}, child: Text('Gallery')),
        ]
      );
    }
    if(status==PermissionStatus.denied){
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: "please allow permission for forther usage!",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM, // or SnackPosition.TOP
          borderRadius: 8,
          margin: EdgeInsets.all(10),
        ),
      );
      openAppSettings();
    }
    if(status==PermissionStatus.permanentlyDenied){
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: "please allow permission for forther usage!",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM, // or SnackPosition.TOP
          borderRadius: 8,
          margin: EdgeInsets.all(10),
        ),
      );
      openAppSettings();
    }

  }

}