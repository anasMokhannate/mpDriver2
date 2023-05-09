// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/services.dart';

class MyCommandController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;
  double money = 0;
  double total_courses = 0;

  bool isActiveOne = false, isActiveTwo = true;
  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      isTrue = true.obs;
      update();
    });
  }
}
