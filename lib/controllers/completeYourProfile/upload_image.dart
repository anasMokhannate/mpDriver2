// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/colors.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/adding_moto.dart';

class UploadImageController extends GetxController {
  MpUser? userBase;
  RxBool loading = false.obs;
  XFile? file;
  File? image;

  selectImage() async {
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

  uploadImage() async {
    String fileName = defaultImage;
    loading.toggle();
    update();

    if (file != null) {
      await FirebaseStorage.instance
          .ref('user-images/${file!.name}')
          .putFile(image!)
          .then((picture) {
        picture.ref.getDownloadURL().then((value) async {
          userBase!.currentPageClient = 'homePage';
          userBase!.currentPageDriver = 'addingMoto';
          userBase!.isActivatedAccount = false;
          userBase!.isVerifiedAccount = true;
          userBase!.profilePicture = value;

          await saveCurrentUser(userBase!).then((value) async {
            await completeUser(userBase!).then((value) {
              Get.offAll(() => AddingMoto(),
                  transition: Transition.rightToLeft);
            });
          });
        });
      });
    } else {
      userBase!.currentPageClient = 'homePage';
      userBase!.currentPageDriver = 'addingMoto';
      userBase!.isActivatedAccount = false;
      userBase!.isVerifiedAccount = true;
      userBase!.profilePicture = fileName;

      await saveCurrentUser(userBase!).then((value) async {
        await completeUser(userBase!).then((value) {
          Get.offAll(() => AddingMoto(), transition: Transition.rightToLeft);
        });
      });
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      update();
    });
    
  }
}
