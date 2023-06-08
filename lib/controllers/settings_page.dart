// ignore_for_file: file_names

import 'package:boxicons/boxicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motopickupdriver/controllers/home_page.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/help_center.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../views/welcome_page.dart';

class SettingController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs, loading = false.obs;
  TextEditingController reason = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool? notificationStatus;
  RxBool visibleLanguage = false.obs;
  delete(context) async {
    _displayTextInputDialog(context, password);
  }

  Future<void> _displayTextInputDialog(BuildContext context, password) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Supprimer mon compte',
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.red,
              height: 1.2,
              fontFamily: 'LatoBold',
            ),
          ),
          content: TextField(
            minLines:
                6, // any number you need (It works as the rows for the textarea)
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) {},
            controller: password,
            style: inputTextStyle,
            decoration: InputDecoration(
              hintText: "Votre avis nous intéresse",
              hintStyle: hintTextStyle,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => HelpCenter(),
                          transition: Transition.rightToLeft);
                    },
                    child: Row(
                      children: [
                        const Icon(Boxicons.bx_help_circle),
                        5.horizontalSpace,
                        Text(
                          'Support',
                          style: bodyTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Annuler',
                      style: hintTextStyle,
                    ),
                  ),
                  10.horizontalSpace,
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await deleteAccount();
                    },
                    child: Text(
                      'Confirmer',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                        height: 1.2,
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  )
                ],
              ),
            ),
            20.verticalSpace,
          ],
        );
      },
    );
  }

  deleteAccount() async {
    userBase!.isDeletedAccount = true;
    try {
      await FirebaseAuth.instance.currentUser!.delete().then((value) {
        deleteUser(userBase!, reason.text).then((value) async {
          await FirebaseAuth.instance.signOut();
          // String fcm = await SessionManager().get('driver_fcm') ?? '';
          await GoogleSignIn(scopes: ['profile', 'email']).signOut();
          await SessionManager().remove("currentUser");
          // await SessionManager().destroy();

          // await SessionManager().set('driver_fcm', fcm);
          isTrue.toggle();
          update();
          Get.delete<HomePageController>();
          Get.offAll(() => WelcomeScreen());

          sendNotification([userBase!.fcm!], "Votre compte a été supprimé",
              "Votre compte a été supprimé avec succès. Merci d'avoir utilisé notre application.");
        });
      });
    } catch (e) {
      showAlertDialogOneButton(
          Get.context!,
          'Connexion récente',
          "Vous avez besoin d'une connexion récente, veuillez vous reconnecter pour pouvoir supprimer votre compte.",
          'Ok');
    }
  }

  checkNotification() async {
    final isActivated =
        await SessionManager().get('isActiveNotificationDriver');
    if (isActivated == null || isActivated == false) {
      notificationStatus = false.obs;

      update();
    } else if (isActivated == true) {
      notificationStatus = true.obs;
      update();
    }
    update();
  }

  switchNotification() async {
    final isActivated =
        await SessionManager().get('isActiveNotificationDriver');
    if (isActivated == true) {
      SessionManager().set('isActiveNotificationDriver', false);
      notificationStatus!.value = !notificationStatus!.value;
      OneSignal.shared.disablePush(true);
    } else {
      SessionManager().set('isActiveNotificationDriver', true);
      notificationStatus = true.obs;
      OneSignal.shared.disablePush(false);
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      isTrue = true.obs;
      checkNotification();
      update();
    });
  }
}
