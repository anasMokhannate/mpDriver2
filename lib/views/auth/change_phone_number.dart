// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/inputs.dart';
import 'package:motopickupdriver/controllers/auth/change_phone_number.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

class ChangePhoneNumberNoAuth extends StatelessWidget {
  ChangePhoneNumberNoAuth({Key? key}) : super(key: key);
  var controller = Get.put(ChangePhoneNumberNoAuthController());

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
                      'Changer mon numéro de téléphone',
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
                        controller: controller.currentPhone,
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
                          hintText: "Entrez l'ancien numéro",
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      height: 70.h,
                      child: TextField(
                        controller: controller.newPhone,
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
                              controller.chnageSecondIndicatif(countryCode);
                            },
                            initialSelection: 'MA',
                            favorite: const ['+212', 'MA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: bodyTextStyle,
                            flagWidth: 25.w,
                          ),
                          hintText: 'Entrez le nouveau numéro',
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
                  InputPasswordField(
                      hintText: "Entrez votre mot de passe",
                      type: TextInputType.text,
                      controller: controller.password),
                  40.verticalSpace,
                  PrimaryButton(
                    text: 'Continuer',
                    function: () async {
                      controller.submit(context);
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
