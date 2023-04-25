// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/completeYourProfile/verify_code.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCode extends StatelessWidget {
  VerifyCode({Key? key}) : super(key: key);
  var controller = Get.put(VerifyCodeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<VerifyCodeController>(
        init: VerifyCodeController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Get.back(),
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
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Vérifiez votre numéro de téléphone',
                      style: primaryHeadlineTextStyle,
                    ),
                  ),
                  40.verticalSpace,
                  GetBuilder<VerifyCodeController>(
                    init: VerifyCodeController(),
                    builder: (value) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Un SMS a été envoyé au ${controller.phoneNumber} , entrez le code reçu pour valider votre inscription.',
                        style: bodyTextStyle,
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      controller: controller.code,
                      pastedTextStyle: bodyTextStyle,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50.w,
                        fieldWidth: 50.w,
                        activeFillColor: Colors.transparent,
                        inactiveFillColor: Colors.transparent,
                        selectedColor: primary,
                        selectedFillColor: Colors.transparent,
                        inactiveColor: border,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        color: dark,
                        height: 1.4,
                        fontFamily: "LatoSemiBold",
                      ),
                      beforeTextPaste: (text) {
                        return true;
                      },
                      onChanged: (String value) {},
                      appContext: context,
                    ),
                  ),
                  40.verticalSpace,
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        controller.message,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.red,
                          height: 1.4,
                          fontFamily: "LatoRegular",
                        ),
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  PrimaryButton(
                    text: "Continuer",
                    function: () {
                      controller.submit(context);
                    },
                  ),
                  40.verticalSpace,
                  InkWell(
                    onTap: () {
                      if (controller.second == 0) {
                        controller.reSendCode(context);
                      }
                    },
                    child: Center(
                      child: GetBuilder<VerifyCodeController>(
                        init: VerifyCodeController(),
                        builder: (value) => Text(
                          "Je n'ai pas reçu le code, cliquez ici dans ${controller.second} secondes",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: controller.second == 0
                                ? dark
                                : dark.withOpacity(0.4),
                            fontFamily: "LatoRegular",
                          ),
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
