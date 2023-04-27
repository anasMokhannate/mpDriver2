import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/auth/recover_account.dart';

class ChangePhoneNumberController extends GetxController {
  TextEditingController currentPhone = TextEditingController();
  TextEditingController newPhone = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool loading = false.obs;

  String indicatif = "+212";
  String secondIndicatif = "+212";

  MpUser? userBase;

  String? oldPhonetxt;

  String? newPhonetxt;

  chnageIndicatif(value) {
    indicatif = value.toString();
  }

  chnageSecondIndicatif(value) {
    indicatif = value.toString();
  }

  Future<bool> validate(context) {
    bool isValid = true;
    if (currentPhone.text.isEmpty || currentPhone.text.length < 9) {
      showAlertDialogOneButton(context, "Numéro de téléphone vide",
          "Votre numéro de téléphone est vide, Veuillez réessayer", "Ok");
      isValid = false;

      // loading.toggle();
      // update();
    } else if (newPhone.text.isEmpty || newPhone.text.length < 9) {
      showAlertDialogOneButton(
          context,
          "Nouveau numéro de téléphone vide",
          "Votre nouveau numéro de téléphone est vide, Veuillez réessayer",
          "Ok");
      isValid = false;

      // loading.toggle();
      // update();
    } else if (password.text.isEmpty) {
      showAlertDialogOneButton(context, "Mot de passe vide",
          "Votre mot de passe est vide, Veuillez réessayer", "Ok");
      isValid = false;

      // loading.toggle();
      // update();
    } else if (currentPhone.text == newPhone.text) {
      showAlertDialogOneButton(
          context,
          "Même numéro de téléphone",
          "Entrez un numéro de téléphone différent du numéro actuel, Veuillez réessayer",
          "Ok");
      isValid = false;
    }
    return Future.value(isValid);
  }

  submit(context) async {
    await validate(context).then((value) async {
      if (value) {
        oldPhonetxt = indicatif + currentPhone.text;
        newPhonetxt = secondIndicatif + newPhone.text;
        await loginWithPhone(oldPhonetxt).then((email) async {
          User? user;
          try {
            UserCredential credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: email, password: password.text);
            user = credential.user;
          } catch (e) {
            showAlertDialogOneButton(
                context,
                "Numéro de téléphone ou mot de passe incorrect",
                "Vos informations sont incorrectes, Veuillez réessayer",
                "Ok");

            currentPhone.text = "";
            newPhone.text = "";
            password.text = "";
          }

          await getUser(user!.uid).then((value) async {
            userBase = value;
            await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: newPhonetxt,
                verificationCompleted: (phonesAuthCredentials) async {},
                verificationFailed: (FirebaseException e) async {
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
                  await SessionManager().set('oldPhone', oldPhonetxt);
                  await SessionManager().set('newPhone', newPhonetxt);
                  await saveCurrentUser(userBase!);
                  await SessionManager()
                      .set('password', password.text)
                      .then((value) {
                    Get.to(() => RecoverAccount(),
                        arguments: verificationId,
                        transition: Transition.rightToLeft);
                    loading.toggle();
                    update();
                  });
                },
                codeAutoRetrievalTimeout: (verificatioId) async {});
          });
        });
      }
    });
  }
}
