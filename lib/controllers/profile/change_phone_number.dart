import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';

import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/profile/re_verify_phone.dart';

class ChangePhoneNumberController extends GetxController {
  RxBool loading = false.obs;
  MpUser? userBase;

  TextEditingController phone = TextEditingController();
  String indicatif = "+212";

  void chnageIndicatif(value) {
    indicatif = value;
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) {
      userBase = value;
    });
  }

  void submit(context) {
    if (phone.text.isEmpty && phone.text.length != 9) {
      showAlertDialogOneButton(context, "Données requises",
          "Vous devez entrer un numéro de telephone correct", "Ok");
    } else if (indicatif + userBase!.phoneNumber! == phone.text) {
      showAlertDialogOneButton(
          context,
          "Données requises",
          "Vous devez entrer un numéro de telephone different de l'ancien",
          "Ok");
    } else {
      loading.toggle();
      update();
      String phoneNumber = indicatif + phone.text;
      checkPhoneNumber(phoneNumber).then((value) async {
        if (value == "not-found") {
          userBase!.phoneNumber = phoneNumber;
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 60),
              verificationCompleted: (phonesAuthCredentials) async {},
              verificationFailed: (FirebaseAuthException e) async {
                loading.toggle();
                if (e.code == 'too-many-requests') {
                  showAlertDialogOneButton(
                      context,
                      'Trop de demandes',
                      "Nous avons bloqué toutes les demandes de cet appareil en raison d'une activité inhabituelle, réessayez",
                      "Ok");
                } else {
                  showAlertDialogOneButton(
                      context, 'Echéc', "Validation a échoué", "Ok");
                  print(e.message);
                }
              },
              codeSent: (verificationId, resendingToken) async {
                userBase!.phoneNumber = phoneNumber;
                await saveCurrentUser(userBase!).then((value) {
                  loading.toggle();
                  update();
                  Get.to(() => ReVerifyPhone(),
                      arguments: verificationId,
                      transition: Transition.rightToLeft);
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {});
        } else {
          showAlertDialogOneButton(
            context,
            'Le numéro de téléphone existe déjà',
            'Veuillez fournir un autre numéro de téléphone',
            'Ok',
          );
          loading.toggle();
          update();
        }
      });
    }
  }
}
