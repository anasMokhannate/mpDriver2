import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController phone = TextEditingController();

  RxBool loading = false.obs;

  String indicatif = "+212";

  chnageIndicatif(value) {
    indicatif = value.toString();
  }

  submit(context) async {}
}
