// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/functions.dart';
import 'package:motopickupdriver/utils/typography.dart';

import '../../controllers/completeYourProfile/verify_phone_number.dart';

class VerifyPhoneNumber extends StatelessWidget {
  VerifyPhoneNumber({Key? key}) : super(key: key);
  var controller = Get.put(VerifyPhoneNumberController());

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
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Boxicons.bx_log_out,
                    color: primary,
                    size: 30.h,
                  ),
                  onPressed: () async {
                    logout(context);
                  },
                )
              ],
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Ajoutez votre numéro de téléphone, nous vous enverrons un code de vérification afin que nous sachions que vous êtes réel.',
                      style: bodyTextStyle,
                    ),
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      height: 70.h,
                      child: TextField(
                        controller: controller.phone,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(9),
                        ],
                        style: inputTextStyle,
                        decoration: InputDecoration(
                          prefixIcon: CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              controller.chnageIndicatif(countryCode);
                            },
                            initialSelection: 'MA',
                            favorite: const ['+212', 'MA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: bodyTextStyle,
                            flagWidth: 25.w,
                          ),
                          hintText: 'Entrez votre numéro de téléphone',
                          hintStyle: hintTextStyle,
                          filled: true,
                          fillColor: Colors.transparent,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: primary, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: border, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  PrimaryButton(
                    text: 'Continuer',
                    function: () async {
                      controller.submit(context);
                      Get.delete<VerifyPhoneNumberController>();
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
