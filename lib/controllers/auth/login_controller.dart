import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/navigations.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';

class LoginController extends GetxController {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool loading = false.obs;
  String indicatif = "+212";

  chnageIndicatif(value) {
    indicatif = value.toString();
  }

  Future<bool> validate(context) async {
    bool isValid = true;
    loading.toggle();
    update();
    if (phone.text.isEmpty || phone.text.length < 9) {
      showAlertDialogOneButton(
          context,
          "Le numéro de téléphone est incorrect",
          "Il n'y a pas d'utilisateur avec ce numéro de téléphone, veuillez vérifier à nouveau ou créer un nouveau compte.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (password.text.isEmpty) {
      showAlertDialogOneButton(context, "Mot de passe incorrect",
          "Veuillez entrer un mot de passe.", "Ok");
      isValid = false;
      loading.toggle();
      update();
    }
    return Future.value(isValid);
  }

  submit(context) async {
    Widget? mainPage;
    await validate(context).then((value) async {
      if (value) {
        String phoneNumber = indicatif + phone.text;
        await loginWithPhone(phoneNumber).then((email) async {
          if (email != null) {
            await getProvider(email).then((provider) async {
              if (provider == "Phone") {
                // try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password.text)
                      .then((credential) async {
                    User? currUser = FirebaseAuth.instance.currentUser;
                    await getUser(currUser!.uid).then((mpUser) async {
                      await saveCurrentUser(mpUser);
                      mainPage = await initWidget();
                      Get.offAll(mainPage);
                      loading.toggle();
                      update();
                    });
                  });
                // } catch (e) {
                //   print("erroooooooooooooooooooooooor $e");
                //   showAlertDialogOneButton(
                //       context,
                //       "Mot de passe incorrect",
                //       "Votre mot de passe est incorrect, Veuillez réessayer",
                //       "Ok");
                //   loading.toggle();
                //   update();
                // }
              } else {
                loading.toggle();
                update();
                showAlertDialogOneButton(
                    context,
                    "L'utilisateur existe déjà",
                    "Il existe déjà un compte avec cet e-mail, veuillez essayer de vous connecter avec $provider",
                    "Ok");
              }
            });
          } else {
            loading.toggle();
            update();
            showAlertDialogOneButton(
                context,
                "L'utilisateur n'existe pas",
                "Il n'y a pas d'utilisateur avec ce numéro de téléphone, veuillez créer un nouveau compte.",
                "Ok");
          }
        });
      }
    });
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }
}
