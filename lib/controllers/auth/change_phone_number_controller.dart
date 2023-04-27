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
        loading.toggle();
        update();
        oldPhonetxt = indicatif + currentPhone.text;
        newPhonetxt = secondIndicatif + newPhone.text;
        await loginWithPhone(oldPhonetxt).then((email) async {
          await getProvider(email ?? "").then((provider) async {
            if (provider != "Phone" && provider != "") {
              currentPhone.text = "";
              newPhone.text = "";
              password.text = "";

              loading.toggle();
              update();

              showAlertDialogOneButton(
                  context,
                  "Numéro de téléphone invalide",
                  "Ce numéro de téléphone est utilisé dans un compte $provider",
                  "Ok");
            } else if (provider == "") {
              currentPhone.text = "";
              newPhone.text = "";
              password.text = "";

              loading.toggle();
              update();

              showAlertDialogOneButton(
                  context,
                  "Numéro de téléphone invalide",
                  "Aucun utilisateur avec ce numéro n'existe, Veuillez réessayer avec un autre numéro de téléphone",
                  "Ok");
            } else {
              await checkPhoneNumber(newPhonetxt!).then((message) async {
                if (message == "found-in-users") {
                  loading.toggle();
                  update();

                  showAlertDialogOneButton(
                      context,
                      "Numéro de téléphone invalide",
                      "Ce numéro est déjà utilisé, Veuillez réessayer avec un autre numéro de téléphone",
                      "Ok");
                } else {
                  User? user;
                  try {
                    UserCredential credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email!, password: password.text);
                    user = credential.user;
                    await getUser(user?.uid).then((value) async {
                      userBase = value;
                      await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: newPhonetxt,
                          verificationCompleted:
                              (phonesAuthCredentials) async {},
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
                  } catch (e) {
                    loading.toggle();
                    update();

                    showAlertDialogOneButton(
                        context,
                        "Numéro de téléphone ou mot de passe incorrect",
                        "Vos informations sont incorrectes, Veuillez réessayer",
                        "Ok");
                  }
                }
              });
            }
          });
        });
      }
    });
  }

  @override
  void onInit() {
    loading.value = false;
    update();
    super.onInit();
  }

  @override
  void dispose() {
    currentPhone.dispose();
    newPhone.dispose();
    password.dispose();
    super.dispose();
  }
}
