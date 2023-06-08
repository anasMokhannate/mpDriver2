import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/adding_moto.dart';

class VerifyCodeController extends GetxController {
  RxBool loading = false.obs;

  MpUser? currUser;
  String phoneNumber = '';
  Duration myDuration = const Duration(seconds: 30);
  TextEditingController code = TextEditingController();

  String message = '', verificationCode = '';
  Timer? countdownTimer;
  int second = 30;
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    second = seconds;
    if (seconds <= 0) {
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(seconds: seconds);
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) {
      currUser = value;
      phoneNumber = currUser!.phoneNumber!;

      verificationCode = Get.arguments;
      startTimer();
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
        }).catchError((e) {
          // loading.toggle();
          // update();
          // showAlertDialogOneButton(
          //     context,
          //     "Code Expiré",
          //     "Le code SMS a expiré. Veuillez renvoyer le code de vérification pour réessayer.",
          //     "Ok");

          message =
              "Erreur lors de la creation du compte, veuillez nous contacter pour régler ce problème";
          loading.toggle();
          update();
        });
      } catch (e) {
        message =
            "Le code SMS a expiré. Veuillez renvoyer le code de vérification pour réessayer.";
        update();
      }
    } else {
      loading.toggle();
      update();
      showAlertDialogOneButton(
          context, "Code requis", "Veuillez entrer le bon code.", "Ok");
    }
  }

  void reSendCode(BuildContext context) async {
    code.clear();
    update();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phonesAuthCredentials) async {},
      verificationFailed: (verificationFailed) async {},
      codeSent: (verificationId, resendingToken) async {
        verificationCode = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
    second = 30;
    myDuration = const Duration(seconds: 30);
    startTimer();
    update();
  }
}
