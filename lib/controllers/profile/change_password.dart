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
        }  on FirebaseAuthException catch (e) {
                  if (e.code == "user-not-found") {
                    showAlertDialogOneButton(
                        context,
                        "L'utilisateur n'existe pas",
                        "Il n'y a pas d'utilisateur avec ce numéro de téléphone, veuillez créer un nouveau compte.",
                        "Ok");
                    loading.toggle();
                    update();
                  } else if (e.code == "wrong-password") {
                    showAlertDialogOneButton(
                        context,
                        "Mot de passe incorrect",
                        "Votre mot de passe est incorrect, Veuillez réessayer",
                        "Ok");
                    loading.toggle();
                    update();
                  }
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
