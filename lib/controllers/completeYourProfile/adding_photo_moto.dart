import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';

import '../../utils/colors.dart';
import '../../utils/models/moto.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/verify_identity.dart';

class AddingPhotoMotoController extends GetxController {
  RxBool loading = false.obs;
  MpUser? userBase;
  Moto? moto;
  XFile? file;
  File? image;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      moto = Moto.fromJson(userBase?.motos![0] as Map<String, dynamic>);
      print(moto);
    });
    update();
  }

  void selectImage() async {
    try {
      file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        image = File(file!.path);
        update();
      }
    } catch (ex) {
      Get.snackbar('Erreur', ex.toString());
      throw ex.toString();
    }
  }

  void uploadImage(BuildContext context) async {
    String fileName = defaultImage;
    loading.toggle();
    update();

    if (file != null) {
      await FirebaseStorage.instance
          .ref('drivers/${file!.name}')
          .putFile(image!)
          .then((picture) {
        picture.ref.getDownloadURL().then((value) async {
          userBase!.currentPageDriver = 'verifyIdentity';
          userBase!.motos!.first['motocycle_photo'] = value;

          await saveCurrentUser(userBase!).then((value) async {
            await completeUser(userBase!).then((value) {
            Get.offAll(() => const VerifyIdentity(),
                transition: Transition.rightToLeft);
          });
          });

          
        });
      });
    } else {
      showAlertDialogOneButton(context, "Photo obligatoire", "la photo de votre moto est obligatoire", "ok");
      loading.toggle();
      update();
      // await completeUser(userBase!).then((value) {
      //   Get.offAll(() => Congrats(), transition: Transition.rightToLeft);
      // });
    }

    // await Get.to(() => const VerifyIdentity(),
    //             transition: Transition.rightToLeft);
  }
}
