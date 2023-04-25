import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../views/completeYourProfile/verify_identity.dart';

class AddingPhotoMotoController extends GetxController{
  var loading;

  var image;

  var file;

  void selectImage() {}

  void uploadImage(BuildContext context) async {

    await Get.to(() => const VerifyIdentity(),
                transition: Transition.rightToLeft);
  }


}