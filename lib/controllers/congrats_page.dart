// ignore_for_file: file_names

import 'package:get/get.dart';


import '../utils/models/user.dart';
import '../utils/services.dart';

class CongratsController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;

  @override
  void onInit() async {
    super.onInit();
    print(
        'Congraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaats');
    Get.snackbar('Congrats', 'Congrats');
    await getUserFromMemory().then((value) async {
      userBase = value;
      isTrue = true.obs;
      update();
    });
  }
}
