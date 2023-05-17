// ignore_for_file: dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/views/completeYourProfile/adding_photo_moto.dart';
import 'package:motopickupdriver/views/completeYourProfile/complete_profile.dart';
import 'package:motopickupdriver/views/onboarding/onboarding_page.dart';
import 'package:motopickupdriver/views/onboarding/using_condition_screen.dart';
import 'package:motopickupdriver/views/order_informations.dart';

import '../views/auth/register_page.dart';
import '../views/completeYourProfile/adding_moto.dart';
import '../views/completeYourProfile/upload_image.dart';
import '../views/completeYourProfile/verify_identity.dart';
import '../views/congrats_page.dart';
import '../views/home_page.dart';
import '../views/welcome_page.dart';
import 'models/user.dart';

Future<Widget?> initWidget() async {
  Widget? mainPage;
  bool isFirstTime = await SessionManager().get('first_time') ?? true;
  bool hasAccepted = await SessionManager().get('hasAccepted') ?? true;
 await SessionManager().get('user_fcm').then((value) {
   print('objects $value');
    });
  if (isFirstTime) {
    mainPage = const OnBoardingPage();
  } else {
    await getUserFromMemory().then((value) async {
      if (value == null) {
        mainPage = WelcomeScreen();
      } else {
        MpUser user = value;
        await getUser(user.uid).then((userFromDb) async {
          print('object ${user.uid} ${userFromDb.currentPageDriver}');
          switch (userFromDb.currentPageDriver) {
            case 'homePage':
              if (userFromDb.currentOrderDriver != null) {
                mainPage = OrderInformations();
              } else {
                mainPage = const HomePage();
              }
              break;
            case 'completeProfile':
              mainPage = CompleteProfile();
              break;
            case 'uploadImage':
              mainPage = UploadImage();
              break;
            case 'registerPage':
              mainPage = RegisterPage();
              break;
            case 'addingMoto':
              mainPage = AddingMoto();
              break;
            case 'addingPhotoMoto':
              mainPage = AddingPhotoMoto();
              break;
            case 'verifyIdentity':
              mainPage = const VerifyIdentity();
              break;
            case 'congratsPage':
              mainPage = Congrats();
              break;
            default:
              await FirebaseAuth.instance.signOut();
              // String fcm = await SessionManager().get('user_fcm')??'';
              await GoogleSignIn(scopes: ['profile', 'email']).signOut();
              await SessionManager().remove("currentUser");
              await SessionManager().set("hasAccepted", false);
              mainPage = const UsingConditionScreen();
              break;
          }
        });
      }
    });
  }

  return mainPage;
}

// Future<Widget?> initWidget() async {
//   bool isVerified = false, isActivated = false;
//   Widget? mainPage;
//   String id = "";
//   bool isLoggedIn = box.read('isLoggedIn') ?? false;
//   print(isLoggedIn);
//   if (isLoggedIn) {
//     try {
//       await getCurrentUser().then((value) async {
//       print(value!.email);
//       isActivated = value.isActivatedAccount!;
//       isVerified = value.isVerifiedAccount!;
//       id = value.uid!;
//     });

//     if (isVerified) {
//       if (isActivated) {
//         await FirebaseFirestore.instance.collection('drivers').doc(id).update({
//           "is_on_order": false,
//         });
//         mainPage = const HomePage();
//       } else {
//         mainPage = Congrats();
//       }
//     } else {
//       mainPage = CompleteProfile();
//     }
//     } catch (e) {
//       mainPage = const OnBoardingPage();

//     }

//   } else {
//     mainPage = const OnBoardingPage();
//   }
//   await checkForUpdate();
//   return mainPage;
// }

AppUpdateInfo? _updateInfo;

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

bool _flexibleUpdateAvailable = false;

// Platform messages are asynchronous, so we initialize in an async method.
Future<bool> checkForUpdate() async {
  bool updateStatus = false;
  InAppUpdate.checkForUpdate().then((info) {
    _updateInfo = info;
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      updateStatus = true;
      InAppUpdate.performImmediateUpdate()
          .catchError((e) => showSnack(e.toString()));
    } else {
      updateStatus = false;
    }
  }).catchError((e) {
    showSnack(e.toString());
    updateStatus = false;
  });

  return updateStatus;
}

goBackOff(Widget target) {
  Get.offAll(() => target, transition: Transition.leftToRight);
}

void showSnack(String text) {
  if (_scaffoldKey.currentContext != null) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
