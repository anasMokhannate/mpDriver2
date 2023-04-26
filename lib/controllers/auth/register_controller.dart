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
    await validate(context).then((isValid) async {
      if (isValid) {
        await checkEmail(email.text.trim()).then((emailExist) async {
          if (emailExist == true) {
            showAlertDialogOneButton(
              context,
              "Email déjà utilisé!",
              "Veuillez saisir un autre Email, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
              "Ok",
            );
            loading.toggle();
            update();
          } else {
            await checkPhoneNumber(indicatif + phone.text).then((message) async {
              if (message == 'found') {
                showAlertDialogOneButton(
                  context,
                  "Numéro de téléphone déjà utilisé!",
                  "Veuillez saisir un autre numéro de téléphone, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
                  "Ok",
                );
                loading.toggle();
                update();
              } else {
                String phoneNumber = indicatif + phone.text;
                SessionManager().set('email', email.text);
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

                    Get.to(() => VerfiyNumber(),
                        arguments: verificationId,
                        transition: Transition.rightToLeft);
                    loading.toggle();
                    update();
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              }
            });
          }
        });
      }

      // if (value) {

      //   await checkEmail(email.text).then((value) {
      //     if (value) {
      //       showAlertDialogOneButton(
      //         context,
      //         "Email déjà utilisé!",
      //         "Veuillez saisir un autre Email, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
      //         "Ok",
      //       );
      //       loading.toggle();
      //       update();
      //     } else {
      //       SessionManager().set('email', email.text);
      //     }
      //   });
      //   String phoneNumber = indicatif + phone.text;
      //   await checkPhoneNumber(phoneNumber).then((message) async {
      //     if (message == "found-in-users") {
      //       showAlertDialogOneButton(
      //         context,
      //         "Numéro de téléphone déjà utilisé!",
      //         "Veuillez saisir un autre numéro de téléphone, car celui-ci est déjà utilisé par un autre compte, ou essayez de vous connecter.",
      //         "Ok",
      //       );
      //       loading.toggle();
      //       update();
      //     }
      //     // await checkEmail(email.text).then((message) async {}
      //     else {
      //       await FirebaseAuth.instance.verifyPhoneNumber(
      //         phoneNumber: indicatif + phone.text,
      //         verificationCompleted: (phonesAuthCredentials) async {},
      //         verificationFailed: (FirebaseAuthException e) async {
      //           loading.toggle();
      //           update();
      //           if (e.code == 'too-many-requests') {
      //             showAlertDialogOneButton(
      //               context,
      //               "Réessayez plus tard",
      //               "Nous avons bloqué toutes les demandes de cet appareil en raison d'une activité inhabituelle",
      //               "Ok",
      //             );
      //           }
      //         },
      //         codeSent: (verificationId, resendingToken) async {
      //           await SessionManager().set('phone', phoneNumber);
      //           await SessionManager().set('password', password.text);

      //           Get.to(() => VerfiyNumber(),
      //               arguments: verificationId,
      //               transition: Transition.rightToLeft);
      //           loading.toggle();
      //           update();
      //         },
      //         codeAutoRetrievalTimeout: (verificationId) async {},
      //       );
      //     }
      //   });
      // }
    });
  }
}
