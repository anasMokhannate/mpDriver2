import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/user.dart';

import '../../utils/services.dart';

class ProfilePageController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      isTrue.toggle();
      update();
    });
  }
}
