// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/auth/new_password.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/auth/login_page.dart';

class NewPassword extends StatelessWidget {
  NewPassword({Key? key}) : super(key: key);
  var controller = Get.put(NewPasswordController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.h,
              title: Image.asset(
                'assets/images/logoMoto_colored.png',
                height: 50.h,
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  65.verticalSpace,
                  Center(
                    child: Icon(
                      Boxicons.bxs_envelope_open,
                      color: primary,
                      size: 65.sp,
                    ),
                  ),
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Vérifiez votre boite email',
                      style: primaryHeadlineTextStyle,
                    ),
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Nous avons envoyé une instruction de récupération de mot de passe à votre adresse e-mail.',
                      style: bodyTextStyle,
                    ),
                  ),
                  20.verticalSpace,
                  40.verticalSpace,
                  PrimaryButton(
                    text: 'Terminer',
                    function: () async {
                      Get.offAll(() => LoginPage(),
                          transition: Transition.rightToLeft);
                    },
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
