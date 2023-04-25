import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/models/user.dart';

class VerifyRecoverController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  RxBool loading = false.obs;
  RxBool isTrue = true.obs;

  String message = "", verificationCode = "", phone = "";

  int second = 30;

  MpUser? user;

  submit(context) async {}

  reSendCode() async {}
}
