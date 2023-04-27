// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../utils/models/user.dart';



class NewPasswordController extends GetxController {
  RxBool loading = false.obs;
  MpUser? user;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmePasswod = TextEditingController();

  // validate(context) {
  //   print(FirebaseAuth.instance.currentUser);
  // }

  // submit(context) async {
  //   validate(context);
  // }

  
  @override
  void dispose() {
    newPassword.dispose();
    confirmePasswod.dispose();

    super.dispose();
  }
}
