// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/services.dart';

class MyBikesController extends GetxController {
  MpUser? userBase;
  List<dynamic>? listMoto;
  RxBool isTrue = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      listMoto = userBase!.motos;
      isTrue = true.obs;
      update();
    });
  }
}
