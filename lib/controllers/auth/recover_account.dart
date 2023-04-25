import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../views/completeYourProfile/complete_profile.dart';
import '../../views/home_page.dart';

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
    print("${oldPhone!} old phone");
    newPhone = await SessionManager().get("newPhone");
    print("${newPhone!} new phone");
    password = await SessionManager().get("password");
    print("${password!} password");
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
          print("emaiiiiiiiiiiiiiiiiiiiiiiiiiiiiil $email");
          PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: code.text);

          User? user = FirebaseAuth.instance.currentUser;
          print("teeeeeeeeeeeeeeeeeeeeeset${user!.email!}");
          user.updatePhoneNumber(phoneCredential).then((_) async {
             print("${user.phoneNumber!} updated email");
              userBase!.lastLoginDate = DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
                  .format(DateTime.now());
              userBase!.phoneNumber = newPhone;
              await completeUser(userBase!);
              await SessionManager().set('currentUser', userBase);
              print("userAddeeeeeeeeeeeeeeeeeeeed ${userBase!.email!}");
              if (userBase!.isVerifiedAccount == false) {
                return Get.offAll(() => CompleteProfile(),
                    transition: Transition.rightToLeft);
              }
              Get.offAll(() => const HomePage(),
                  transition: Transition.rightToLeft);
            });
          });
        }
      catch (e) {
        print(e.toString());
        Get.snackbar('Error', 'Please enter code teeeeeeeeeeeeeeest');
      }
    } else {
      Get.snackbar('Error', 'Please enter code');
    }
  }
}


