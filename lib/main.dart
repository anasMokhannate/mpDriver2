import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/navigations.dart';
import 'package:motopickupdriver/utils/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await FlutterBackground.initialize().then((value) async {
  //   await FlutterBackground.enableBackgroundExecution().then((value) {
  //     print('background enabled $value');
  //   });
  // });

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await FirebaseFirestore.instance.clearPersistence();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  await handlerPermission();
  await initOneSignal();
  await checkIsFirstTime();
  GeoFlutterFire geo;
  Widget? mainPage;
  await initWidget().then((page) {
    mainPage = page;
  });
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('fr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return GetMaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Moto Pick-up Driver',
            theme: ThemeData(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: primary,
                  ),
              primaryColor: primary,
            ),
            home: mainPage,
          );
        },
      ),
    ),
  );
}
