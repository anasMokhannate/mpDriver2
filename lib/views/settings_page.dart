// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/settings_page.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/functions.dart';
import 'package:motopickupdriver/utils/navigations.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/about_us.dart';
import 'package:motopickupdriver/views/home_page.dart';
import 'package:motopickupdriver/views/my_bikes.dart';

//SettingScreen
class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  var controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => goBackOff(HomePage()),
      child: GetBuilder<SettingController>(
        init: SettingController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: scaffold,
              appBar: !controller.isTrue.value
                  ? AppBar(
                      leading: Icon(
                        Boxicons.bx_grid_alt,
                        color: Colors.transparent,
                        size: 35.h,
                      ),
                      toolbarHeight: 80.h,
                      title: Image.asset(
                        'assets/images/logoMoto_colored.png',
                        height: 50.h,
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    )
                  : AppBar(
                      leading: InkWell(
                        onTap: () => goBackOff(HomePage()),
                        child: Icon(
                          Boxicons.bx_arrow_back,
                          color: primary,
                          size: 30.h,
                        ),
                      ),
                      toolbarHeight: 80.h,
                      title: Image.asset(
                        'assets/images/logoMoto_colored.png',
                        height: 50.h,
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
              body: !controller.isTrue.value
                  ? Center(
                      child: SizedBox(
                        width: 225.w,
                        child: const LoadingIndicator(
                            indicatorType: Indicator.ballScaleMultiple,
                            colors: [primary],
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            pathBackgroundColor: Colors.black),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Paramètres',
                            style: primaryHeadlineTextStyle,
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Container(
                                height: 60.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    15.horizontalSpace,
                                    Container(
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                        color: primary.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(360),
                                      ),
                                      child: Icon(
                                        Boxicons.bx_world,
                                        color: primary,
                                        size: 20.h,
                                      ),
                                    ),
                                    15.horizontalSpace,
                                    Text(
                                      'Langue',
                                      style: darkButtonTextStyle,
                                    ),
                                    const Spacer(),
                                    Text(
                                      context.locale.toString() == 'fr'
                                          ? 'Français'
                                          : 'العربية',
                                      style: hintTextStyle,
                                    ),
                                    10.horizontalSpace,
                                    Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        color: dark.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Boxicons.bx_chevron_right,
                                        color: dark,
                                      ),
                                    ),
                                    15.horizontalSpace,
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              context.locale.toString() == 'fr'
                                  ? context.setLocale(const Locale('ar'))
                                  : context.setLocale(const Locale('fr'));
                              // Get.to(() => MyBikes());
                            }),
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            height: 60.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                15.horizontalSpace,
                                Container(
                                  height: 40.h,
                                  width: 40.h,
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Icon(
                                    Boxicons.bx_bell,
                                    color: primary,
                                    size: 20.h,
                                  ),
                                ),
                                15.horizontalSpace,
                                Text(
                                  'Notifications',
                                  style: darkButtonTextStyle,
                                ),
                                const Spacer(),
                                FlutterSwitch(
                                  value: controller.notificationStatus!.value,
                                  onToggle: (value) {
                                    controller.switchNotification();
                                  },
                                  activeColor: primary,
                                ),
                                15.horizontalSpace,
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                          onTap: () {
                            Get.to(() => MyBikes());
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              height: 60.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  15.horizontalSpace,
                                  Container(
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.motorcycle,
                                      color: primary,
                                      size: 20.h,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                  Text(
                                    'Mes véhicules',
                                    style: darkButtonTextStyle,
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      color: dark.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Boxicons.bx_chevron_right,
                                      color: dark,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                          onTap: () {
                            Get.to(() => const AboutUspage(),
                                transition: Transition.rightToLeft);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              height: 60.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  15.horizontalSpace,
                                  Container(
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Icon(
                                      Boxicons.bx_help_circle,
                                      color: primary,
                                      size: 20.h,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                  Text(
                                    'A propos de l’application',
                                    style: darkButtonTextStyle,
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      color: dark.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Boxicons.bx_chevron_right,
                                      color: dark,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                          onTap: () {
                            logout(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              height: 60.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  15.horizontalSpace,
                                  Container(
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Icon(
                                      Boxicons.bx_help_circle,
                                      color: Colors.red,
                                      size: 20.h,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                  Text(
                                    'Déconnecter',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.red,
                                      fontFamily: 'LatoSemiBold',
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Boxicons.bx_chevron_right,
                                      color: Colors.red,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                          onTap: () {
                            controller.delete(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              height: 60.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  15.horizontalSpace,
                                  Container(
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Icon(
                                      Boxicons.bx_trash,
                                      color: Colors.red,
                                      size: 20.h,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                  Text(
                                    'Supprimer mon compte',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.red,
                                      fontFamily: 'LatoSemiBold',
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Boxicons.bx_chevron_right,
                                      color: Colors.red,
                                    ),
                                  ),
                                  15.horizontalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
