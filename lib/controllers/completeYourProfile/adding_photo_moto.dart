
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../utils/models/moto.dart';
import '../../utils/models/user.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/verify_identity.dart';

class AddingPhotoMotoController extends GetxController{
  RxBool loading = false.obs;
  MpUser? userBase;
  Moto? moto;
  XFile? file;
  File? image ;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      moto = Moto.fromJson( userBase?.motos![0] as Map<String, dynamic>);
      print(moto);
    });
    update();
  }

  void selectImage() {}

  void uploadImage(BuildContext context) async {



    // await Get.to(() => const VerifyIdentity(),
    //             transition: Transition.rightToLeft);
  }


}