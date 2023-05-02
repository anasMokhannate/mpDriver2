import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/profile/main_page.dart';

class EditImageController extends GetxController {
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
      throw ex.toString();
    }
  }

  uploadImage(context) {
    loading.toggle();

    if (file == null) {
      loading.toggle();
      update();
      showAlertDialogOneButton(
          context, "Photo requise ", "Veuillez ajouter une photo", "accepter");
    } else {
      FirebaseStorage.instance
          .ref('user-images/${file!.name}')
          .putFile(image!)
          .then((picture) {
        picture.ref.getDownloadURL().then((value) async {
          userBase!.profilePicture = value;
          userBase!.isVerifiedAccount = true;
          await saveCurrentUser(userBase!);
          completeUser(userBase!).then((value) {
            Get.offAll(() => ProfilePage(), transition: Transition.leftToRight);
          });
        });
      });
    }
    update();
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
