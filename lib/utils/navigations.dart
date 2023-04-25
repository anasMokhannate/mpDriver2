// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/views/completeYourProfile/complete_profile.dart';
import 'package:motopickupdriver/views/onboarding/onboarding_page.dart';
import 'package:motopickupdriver/views/updatePage.dart';

import '../views/congrats_page.dart';
import '../views/home_page.dart';

GetStorage box = GetStorage();

Future<Widget?> initWidget() async {
  bool isVerified = false, isActivated = false;
  Widget? mainPage;
  String id = "";
  bool isLoggedIn = box.read('isLoggedIn') ?? false;
  print(isLoggedIn);
  if (isLoggedIn) {
    try {
      await getCurrentUser().then((value) async {
      print(value!.driver_email);
      isActivated = value!.is_activated_account;
      isVerified = value.is_verified_account;
      id = value.driver_uid;
    });

    if (isVerified) {
      if (isActivated) {
        await FirebaseFirestore.instance.collection('drivers').doc(id).update({
          "is_on_order": false,
        });
        mainPage = const HomePage();
      } else {
        mainPage = Congrats();
      }
    } else {
      mainPage = CompleteProfile();
    }
    } catch (e) {
      mainPage = const OnBoardingPage();
      
    }
    
  } else {
    mainPage = const OnBoardingPage();
  }
  await checkForUpdate();
  return mainPage;
}

goTo(Widget target) {
  Get.to(() => target, transition: Transition.rightToLeft);
}

goToOff(Widget target) {
  Get.offAll(() => target, transition: Transition.rightToLeft);
}

goBackOff(Widget target) {
  Get.offAll(() => target, transition: Transition.leftToRight);
}

AppUpdateInfo? _updateInfo;

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

void showSnack(String text) {
  if (_scaffoldKey.currentContext != null) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
