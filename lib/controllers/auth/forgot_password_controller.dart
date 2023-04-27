import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/queries.dart';
import '../../views/auth/verify_recover_pwd.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController phone = TextEditingController();

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
        "Numéro de téléphone incorrect",
        "Veuillez entrer un numéro de téléphone correct pour récupérer votre mot de passe.",
        "Ok",
      );
      loading.toggle();
      update();
      isValid = false;
    }

    return isValid;
  }

  submit(context) async {
    await validate(context).then((value) async {
      if (value) {
        String phoneNumber = indicatif + phone.text;
        await checkPhoneNumber(phoneNumber).then((message) async {
          if (message == 'found-in-users') {
            try {
              await FirebaseFirestore.instance
                  .collection('mp_users')
                  .where("phone_number", isEqualTo: phoneNumber)
                  .snapshots()
                  .first
                  .then((value) async {
                if (value.docs[0]['auth_type'] != 'Google' &&
                    value.docs[0]['auth_type'] != 'Facebook') {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
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
                      Get.to(() => VerifyRecoverPwd(),
                          transition: Transition.rightToLeft,
                          arguments: verificationId);
                      loading.toggle();
                      update();
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                } else {
                  showAlertDialogOneButton(
                    context,
                    "Erreur",
                    "Ce compte est lié avec un compte ${value.docs[0]['auth_type']}, essayer de connecter avec votre compte",
                    "Ok",
                  );
                  loading.toggle();
                  update();
                }
              });
            } catch (e) {
              print("error $e");
              loading.toggle();
              update();
            }
          } else {
            showAlertDialogOneButton(
                context,
                "Utilisateur non trouvé",
                "Il n'y a pas d'utilisateur avec ce numéro de téléphone, veuillez vérifier à nouveau ou créer un nouveau compte.",
                "Ok");
            loading.toggle();
            update();
          }
        });
      }
    });
  }
}
