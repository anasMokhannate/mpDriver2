import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../views/completeYourProfile/verify_code.dart';

class VerifyPhoneNumberController extends GetxController {
  TextEditingController phone = TextEditingController();
  RxBool loading = false.obs;

  String indicatif = '+212';

  MpUser? currUser;

  @override
  void onInit() async {
    super.onInit();
    currUser = MpUser.fromJson(await SessionManager().get('currentUser'));
    currUser!.currentPage = "VerifyPhoneNumber";
    update();
  }

  chnageIndicatif(value) {
    indicatif = value;
  }

  void submit(BuildContext context) {
    if (phone.text.isEmpty || phone.text.length > 9) {
      showAlertDialogOneButton(
          context, "Code requis", "Veuillez entrer le bon code.", "Ok");
    } else {
      loading.toggle();
      update();
      String phoneNumber = indicatif + phone.text;
      checkPhoneNumber(phoneNumber).then((value) async {
        if (value == "not-found") {
          currUser!.phoneNumber = phoneNumber;
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 60),
              verificationCompleted: (phonesAuthCredentials) async {},
              verificationFailed: (FirebaseAuthException e) async {
                loading.toggle();
                if (e.code == 'too-many-requests') {
                  showAlertDialogOneButton(
                      context,
                      'Trop de demandes',
                      "Nous avons bloqué toutes les demandes de cet appareil en raison d'une activité inhabituelle, réessayez",
                      "Ok");
                } else {
                  showAlertDialogOneButton(
                      context, 'Echéc', "Validation a échoué", "Ok");
                  print(e.message);
                }
              },
              codeSent: (verificationId, resendingToken) async {
                currUser!.phoneNumber = phoneNumber;
                SessionManager().set("currentUser", currUser);
                loading.toggle();
                update();
                Get.to(() => VerifyCode(),
                    arguments: verificationId,
                    transition: Transition.rightToLeft);
              },
              codeAutoRetrievalTimeout: (verificationId) async {});
        } else {
          showAlertDialogOneButton(
            context,
            'Le numéro de téléphone existe déjà',
            'Veuillez fournir un autre numéro de téléphone',
            'Ok',
          );
          loading.toggle();
          update();
        }
      });
    }
  }
}
