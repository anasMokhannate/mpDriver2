// ignore_for_file: file_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import '../../views/completeYourProfile/complete_profile.dart';

class VerfiyNumberController extends GetxController {
  TextEditingController code = TextEditingController();
  RxBool loading = false.obs, isTrue = true.obs;
  int second = 30;
  String message = '', verificationCode = '';
  String? phoneNumber, password, email;

  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);
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

  reSendCode() async {
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

  submit(context) async {
    // if (code.text.isNotEmpty) {
    //   loading.toggle();
    //   update();
    //   try {
       
    //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //         verificationId: verificationCode, smsCode: code.text);
    //     AuthCredential emailCredential = EmailAuthProvider.credential(
    //       email: email!,
    //       password: password!,
    //     );
    //     UserCredential authResult =
    //         await FirebaseAuth.instance.signInWithCredential(credential);
    //     User? user = authResult.user;
        
    //     user!.linkWithCredential(emailCredential).then((value) async {
    //       MpUser userBase = MpUser(
    //         uid: user.uid,
    //         email: email,
    //         phoneNumber: phoneNumber,
    //         authType: 'Phone',
    //         isActivatedAccount: false,
    //         currentPage: 'completeProfile',
    //         isDriver: false,
    //         lastLoginDate:
    //             DateFormat("dd-MM-yyyy HH:mm", "Fr_fr").format(DateTime.now()),
    //         registrationDate:
    //             DateFormat("dd-MM-yyyy HH:mm", "Fr_fr").format(DateTime.now()),
    //         isDeletedAccount: false,
    //         isVerifiedAccount: true,
    //       );
    //       await SessionManager().set('currentUser', userBase);
    //       await createUser(userBase);
    //     });

        Get.offAll(() => CompleteProfile());
        loading.toggle();
        update();

       
  //     } catch (e) {
  //       showAlertDialogOneButton(
  //           context, "Code requis", "Veuillez entrer le bon code.", "Ok");
  //       loading.toggle();
  //       update();
  //       Get.snackbar('catch', 'catch');
  //     }
  //   } else {
  //     showAlertDialogOneButton(
  //         context, "Code requis", "Veuillez entrer le bon code.", "Ok");
  //   }
  // }

  @override
  void onInit() async {
    super.onInit();
    phoneNumber = await SessionManager().get('phone');
    password = await SessionManager().get('password');
    email = await SessionManager().get('email');
    verificationCode = Get.arguments;
    isTrue = false.obs;

    startTimer();
    update();
  }
}}