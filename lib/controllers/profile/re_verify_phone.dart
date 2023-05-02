import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/profile/main_page.dart';

class ReVerifyPhoneController extends GetxController {
  TextEditingController code = TextEditingController();

  MpUser? userBase;
  String message = "", verificationCode = "", phoneNumber = "";

  RxBool loading = false.obs;

  get second => null;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) {
      userBase = value;
      print("useeeeeeeeeeeeeeeeeeeeeeeeeer ${userBase!}");
      phoneNumber = userBase!.phoneNumber!;
      print(phoneNumber);
      verificationCode = Get.arguments;
      //startTimer();
      update();
    });
  }

  void submit(BuildContext context) {
    if (code.text.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: code.text);
      try {
        loading.toggle();
        update();
        FirebaseAuth.instance.currentUser!
            .updatePhoneNumber(credential)
            .then((value) async {
          userBase!.phoneNumber = phoneNumber;
          await saveCurrentUser(userBase!).then((value) async {
            await completeUser(userBase!).then((value) {
              Get.to(() => ProfilePage(), transition: Transition.rightToLeft);
              showAchievementView(context, "Changement de numéro de téléphone", "Votre numéro de téléphone a été changé avec succès.");
            });
          });
        });
      } catch (e) {
        message =
            "Le code SMS a expiré. Veuillez renvoyer le code de vérification pour réessayer.";
        update();
      }
    } else {
      showAlertDialogOneButton(
          context, "Code requis", "Veuillez entrer le bon code.", "Ok");
      loading.toggle();
      update();
    }
  }

  void reSendCode(BuildContext context) {}
}
