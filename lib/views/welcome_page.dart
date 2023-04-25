// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/welcome_page.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/auth/login_page.dart';
import 'package:motopickupdriver/views/auth/register_page.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  var controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScoop(context),
      child: SafeArea(
        child: Scaffold(
          body: Obx(
            () => LoadingOverlay(
              isLoading: controller.loading.value,
              color: dark,
              progressIndicator: const CircularProgressIndicator(
                color: dark,
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                      "assets/images/welcome.jpg",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/Logo_x3.png',
                          height: 80.r,
                        ),
                        85.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'welcomeTitle',
                            style: lightHeadlineTextStyle,
                          ).tr(),
                        ),
                        40.verticalSpace,
                        SocialButton(
                          color: Colors.red,
                          text: 'Connectez-vous avec Google',
                          icon: FontAwesomeIcons.google,
                          function: () {
                            controller.googleAuth(context);
                          },
                        ),
                        /*  20.verticalSpace,
                        SocialButton(
                          color: const Color(0xFF0961B8),
                          text: 'Connectez-vous avec Facebook',
                          icon: FontAwesomeIcons.facebookF,
                          function: () async {
                            controller.facebookAuth();
                          },
                        ), */
                        20.verticalSpace,
                        PhoneButton(
                          color: Colors.white,
                          text: 'Connectez-vous avec votre téléphone',
                          function: () {
                            Get.to(() => LoginPage(),
                                transition: Transition.rightToLeft);
                          },
                        ),
                        20.verticalSpace,
                        InkWell(
                          onTap: () {
                            Get.to(() => RegisterPage(),
                                transition: Transition.rightToLeft);
                          },
                          child: Container(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              "Nouveau parmi nous ? S'inscrire",
                              style: TextStyle(
                                fontFamily: "LatoSemiBold",
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        40.verticalSpace,
                        /*  SupportButton(
                              mode: light,
                            ), */
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
