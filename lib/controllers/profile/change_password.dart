import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/functions.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/views/profile/main_page.dart';

class ChangePasswordController extends GetxController {
  RxBool loading = false.obs;
  bool isValid = true;
  MpUser? userBase;

  TextEditingController currentPassword = TextEditingController();

  TextEditingController newPassword = TextEditingController();

  TextEditingController confirmePasswod = TextEditingController();

  Future<bool> validate(context) {
    if (!validatePassword(currentPassword.text)) {
      showAlertDialogOneButton(
          context,
          "Mot de passe incorrect",
          "Votre mot de passe doit comporter au moins 9 caractères et au moins un chiffre et une lettre.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (!validatePassword(newPassword.text)) {
      showAlertDialogOneButton(
          context,
          "Mot de passe incorrect",
          "Votre mot de passe doit comporter au moins 9 caractères et au moins un chiffre et une lettre.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (newPassword.text != confirmePasswod.text) {
      showAlertDialogOneButton(
          context,
          "Mot de passe incorrect",
          "S'il vous plaît vérifier votre mot de passe. les deux mots de passe doivent être identiques.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    }

    return Future.value(isValid);
  }

  submit(context) async {
    loading.toggle();
    update();
    print("sub 1");
    await validate(context).then((valid) async {
      print("sub 2");
      if (valid) {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: userBase!.email!, password: currentPassword.text)
              .then((_) {
            print("sub 3 ${user!.phoneNumber}");

            user.updatePassword(newPassword.text).then((_) {
              loading.toggle();
              update();
              Get.to(() => ProfilePage(), transition: Transition.rightToLeft);
              showAchievementView(
                  context,
                  "Mot de passe mis à jour avec succès",
                  "Votre mot de passe a été mis à jour avec succès.");
            });
          });
        } catch (e) {
          loading.toggle();
          update();
          showAlertDialogOneButton(context, "Mot de passe incorrect",
              "Vous aver entré un mot de passe incorrecte.", "Ok");
        }
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      loading.value = false;
      update();
    });
  }
}
