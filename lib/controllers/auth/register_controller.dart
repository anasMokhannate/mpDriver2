import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/functions.dart';
import '../../utils/queries.dart';
import '../../views/auth/verify_number.dart';

class RegisterController extends GetxController {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();

  RxBool loading = false.obs;
  String indicatif = "+212";
  String message = "";

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
          "veuillez entrer un numéro de téléphone correct, devrait être 9 chiffres.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (!validatePassword(password.text)) {
      showAlertDialogOneButton(
          context,
          "Mot de passe incorrect",
          "Votre mot de passe doit comporter au moins 9 caractères et au moins un chiffre et une lettre.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (password.text != confirmPassword.text) {
      showAlertDialogOneButton(
          context,
          "Mot de passe incorrect",
          "S'il vous plaît vérifier votre mot de passe. les deux mots de passe doivent être identiques.",
          "Ok");
      isValid = false;
      loading.toggle();
      update();
    } else if (!validateEmail(email.text)) {
      showAlertDialogOneButton(context, "Email incorrect",
          "S'il vous plaît vérifier votre email.", "Ok");
      isValid = false;
      loading.toggle();
      update();
    }

    return Future.value(isValid);
  }

  submit(context) async {
    await validate(context).then((value) async {
      if (value) {
        await checkPhoneNumber(indicatif + phone.text).then((message) async {
          if (message == "found-in-users") {
            loading.toggle();
            update();
            showAlertDialogOneButton(
              context,
              "Numéro de téléphone déjà utilisé!",
              "Veuillez saisir un autre numéro de téléphone, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
              "Ok",
            );
          } else {
            await checkEmail(email.text.trim()).then((emailFound) async {
              if (emailFound) {
                loading.toggle();
                update();
                showAlertDialogOneButton(
                  context,
                  "Email déjà utilisé!",
                  "Veuillez saisir un autre Email, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
                  "Ok",
                );
              } else {
                String phoneNumber = indicatif + phone.text;
                SessionManager().set('email', email.text);
                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: indicatif + phone.text,
                    verificationCompleted: (phonesAuthCredentials) async {},
                    verificationFailed: (FirebaseAuthException e) async {
                      loading.toggle();
                      update();
                      if (e.code == 'too-many-requests') {
                        showAlertDialogOneButton(
                          context,
                          "Réessayez plus tard",
                          "Nous avons bloqué toutes les demandes de cet appareil en raison d'une activité inhabituelle",
                          "Ok",
                        );
                      }
                    },
                    codeSent: (verificationId, resendingToken) async {
                      await SessionManager().set('phone', phoneNumber);
                      await SessionManager().set('password', password.text);
                      loading.toggle();
                      update();
                      Get.to(() => VerfiyNumber(),
                          arguments: verificationId,
                          transition: Transition.rightToLeft);
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                } catch (e) {
                  showAlertDialogOneButton(
                      context, 'Echéc', "Validation a échoué", "Ok");
                  loading.toggle();
                  update();
                }
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}
