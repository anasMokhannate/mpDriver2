import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/adding_moto.dart';
import '../../views/congrats_page.dart';

class VerifyCodeController extends GetxController {
  RxBool loading = false.obs;

  MpUser? currUser;
  String phoneNumber = '';

  TextEditingController code = TextEditingController();

  String message = '', verificationCode = '';

  var second;

  @override
  void onInit() async {
    super.onInit();
      currUser = MpUser.fromJson(await SessionManager().get("currentUser"));
      phoneNumber = currUser!.phoneNumber!;
      print(phoneNumber);
      verificationCode = Get.arguments;
      //startTimer();
      update();
    

  }

  void submit(BuildContext context) {
    if (code.text.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: code.text);
      try {
        loading.toggle();
        update();
        FirebaseAuth.instance.currentUser!
            .linkWithCredential(credential)
            .then((value) async {
          currUser!.isVerifiedAccount = true;
          currUser!.phoneNumber = phoneNumber;
          currUser!.currentPageClient = "homePage";
          currUser!.currentPageDriver = "addingMoto";

          completeUser(currUser!).then((value) {
            saveCurrentUser(currUser!);
            Get.to(() => AddingMoto());
          });
        }).catchError((e) {});
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
