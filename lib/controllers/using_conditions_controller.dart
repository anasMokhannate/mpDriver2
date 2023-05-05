import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/views/welcome_page.dart';

class UsingConditionController extends GetxController {
  RxBool isAccepted = false.obs;
  bool hasAccepted = false;

  @override
  void onInit() async {
    super.onInit();
    await SessionManager().set('hasAccepted', false);
  }

  void next(context) {
    hasAccepted = isAccepted.value;
    if (hasAccepted) {
      SessionManager().set('hasAccepted', hasAccepted);
      Get.to(() => WelcomeScreen(), transition: Transition.rightToLeft);
    } else {
      showAlertDialogOneButton(
          context,
          "Obligatoire",
          "Vous devez accepter les conditions d'utilisations pour utiliser l'application",
          "Ok");
    }
    SessionManager().set('hasAccepted', hasAccepted);
  }
}
