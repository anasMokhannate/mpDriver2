// ignore_for_file: must_be_immutable
import 'package:boxicons/boxicons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/inputs.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/auth/register_page.dart';
import 'package:motopickupdriver/views/welcome_page.dart';
import '../../controllers/auth/login_controller.dart';
import 'change_phone_number.dart';
import 'forgot_password.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  var controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: Scaffold(
            backgroundColor: scaffold,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Get.offAll(() => WelcomeScreen(),
                    transition: Transition.leftToRight),
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
                      'Ravis de vous revoir!',
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
                  InputPasswordField(
                    hintText: 'Entrez votre mot de passe',
                    type: TextInputType.text,
                    controller: controller.password,
                  ),
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ForgotPassword(),
                              transition: Transition.rightToLeft);
                        },
                        child: Text(
                          'Mot de passe oubliée?',
                          style: linkTextStyle,
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  PrimaryButton(
                    text: "Se Connecter",
                    function: () {
                      controller.submit(context);
                    },
                  ),
                  40.verticalSpace,
                  InkWell(
                    onTap: () {
                      Get.to(() => ChangePhoneNumberNoAuth(),
                      transition: Transition.rightToLeft);
                    },
                    child: Center(
                      child: Text(
                        "J'ai changé mon numéro de téléphone",
                        style: linkTextStyle,
                      ),
                    ),
                  ),
                  165.verticalSpace,
                  InkWell(
                    onTap: () {
                      Get.to(() => RegisterPage(),
                          transition: Transition.rightToLeft);
                    },
                    child: Center(
                      child: SizedBox(
                        height: 50.h,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Nouveau parmi nous ? S'inscrire",
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
