// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../components/inputs.dart';
import '../../controllers/auth/register_controller.dart';
import '../../utils/buttons.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  var controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<RegisterController>(
        init: RegisterController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: 
            Scaffold(
              backgroundColor: scaffold,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
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
                        'Bienvenue!\nCréez votre compte',
                        style: primaryHeadlineTextStyle,
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
                    10.verticalSpace,
                    InputTextField(
                      hintText: 'Entrez votre Email',
                      type: TextInputType.emailAddress,
                      controller: controller.email,
                      icon: Boxicons.bxs_envelope,
                    ),
                    10.verticalSpace,
                    InputPasswordField(
                      hintText: 'Entrez votre mot de passe',
                      type: TextInputType.text,
                      controller: controller.password,
                    ),
                    10.verticalSpace,
                    InputPasswordField(
                      hintText: 'Confirmez votre mot de passe',
                      type: TextInputType.text,
                      controller: controller.confirmPassword,
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'En cliquant sur "Confirmer", vous acceptez  ',
                          style: bodyTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'les conditions générales',
                              style: linkTextStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrlString(
                                    'https://motopickup.net/conditions-generales-dutilisation.html',
                                  );
                                },
                            ),
                            TextSpan(
                              text: ' et',
                              style: bodyTextStyle,
                            ),
                            TextSpan(
                              text: " termes d'utilisation",
                              style: linkTextStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrlString(
                                    'https://motopickup.net/termes-de-references.html',
                                  );
                                },
                            ),
                            TextSpan(
                              text: ' de Motopickup.',
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    PrimaryButton(
                      text: "Confirmer",
                      function: () {
                        controller.submit(context);
                      },
                    ),
                    20.verticalSpace,
                    Padding(
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
                    10.verticalSpace,
                    InkWell(
                      onTap: () => Get.to(() => LoginPage(),
                          transition: Transition.leftToRight),
                      child: Center(
                        child: SizedBox(
                          height: 50.h,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Vous êtes déjà client Motopickup? Se Connecter",
                              style: inputTextStyle,
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
