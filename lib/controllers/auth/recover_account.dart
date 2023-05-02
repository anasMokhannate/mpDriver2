import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/views/auth/login_page.dart';

import '../../utils/models/user.dart';
import '../../utils/queries.dart';

class RecoverAccountController extends GetxController {
  TextEditingController code = TextEditingController();
  RxBool loading = false.obs, isTrue = true.obs;
  int second = 30;
  String message = '', verificationCode = '', phone = '';

  String? oldPhone;
  String? newPhone;
  String? password;

  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);

  MpUser? userBase;

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  @override
  void onInit() async {
    super.onInit();
    verificationCode = Get.arguments;
    oldPhone = await SessionManager().get("oldPhone");
    newPhone = await SessionManager().get("newPhone");
    password = await SessionManager().get("password");
    userBase = MpUser.fromJson(await SessionManager().get("currentUser"));
    isTrue.toggle();
    startTimer();
    update();
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

  reSendCode() async {
    code.clear();
    update();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: newPhone!,
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

  void submit(BuildContext context) async {
    if (code.text.isNotEmpty && code.text.length == 6) {
      loading.toggle();
      update();
      try {
        await loginWithPhone(oldPhone).then((email) async {
          PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: code.text);

          User? user = FirebaseAuth.instance.currentUser;

          user!.updatePhoneNumber(phoneCredential).then((_) async {
            userBase!.phoneNumber = newPhone;
            await completeUser(userBase!).then((value) async {
              await FirebaseAuth.instance.signOut().then((value) async {
                await SessionManager().remove("currentUser");
                Get.offAll(() => LoginPage(),
                    transition: Transition.rightToLeft);
              });
            });
          });
        });
      } catch (e) {
         showAlertDialogOneButton(context, "Erreur", "Une erreur est déclenchée, veilliez réessayer plus tard.", "Ok");
      }
    } else {
      showAlertDialogOneButton(context, "Code", "Code est obligatoire", "Ok");
    }
  }
}
