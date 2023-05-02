// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/components/cards.dart';
import 'package:motopickupdriver/components/connectivityWrapper.dart';
import 'package:motopickupdriver/controllers/profile/main_page.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/navigations.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/home_page.dart';
import 'package:motopickupdriver/views/profile/change_password.dart';
import 'package:motopickupdriver/views/profile/change_phone_number.dart';
import 'package:motopickupdriver/views/profile/edit_image.dart';
import 'package:motopickupdriver/views/profile/edit_info.dart';

class ProfilePage extends StatelessWidget {
  var controller = Get.put(ProfilePageController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => goBackOff(const HomePage()),
      child: SafeArea(
        child: GetBuilder<ProfilePageController>(
          init: ProfilePageController(),
          builder: (value) => connectivityWrapper(
            connectivityWrapper(
              Scaffold(
                backgroundColor: scaffold,
                appBar: !controller.isTrue.value
                    ? AppBar(
                        leading: Icon(
                          Boxicons.bx_arrow_back,
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
                          onTap: () => goBackOff(const HomePage()),
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
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            45.verticalSpace,
                            Center(
                              child: SizedBox(
                                height: 120.h,
                                width: 120.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(360),
                                  child: Image.network(
                                    controller.userBase!.profilePicture!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            25.verticalSpace,
                            Text(
                              controller.userBase!.fullName!,
                              style: darkButtonTextStyle,
                            ),
                            45.verticalSpace,
                            ProfileCard(
                              icon: Boxicons.bx_user,
                              text: 'Modifier les données personnelles',
                              function: () {
                                Get.to(() => EditInfo(),
                                    transition: Transition.rightToLeft);

                                Get.delete<ProfilePageController>();
                              },
                            ),
                            20.verticalSpace,
                            ProfileCard(
                              icon: Boxicons.bx_phone,
                              text: 'Changer mon numéro de téléphone',
                              function: () {
                                Get.to(() => ChangePhoneNumber(),
                                    transition: Transition.rightToLeft);
                                Get.delete<ProfilePageController>();
                              },
                            ),
                            controller.userBase!.authType == "Phone"
                                ? 20.verticalSpace
                                : 0.verticalSpace,
                            controller.userBase!.authType == "Phone"
                                ? ProfileCard(
                                    icon: Boxicons.bx_lock,
                                    text: 'Changer mon mot de passe',
                                    function: () {
                                      Get.to(() => ChangePassword(),
                                          transition: Transition.rightToLeft);
                                    },
                                  )
                                : Container(),
                            20.verticalSpace,
                            ProfileCard(
                              icon: Boxicons.bx_image,
                              text: 'Changer ma photo de profil',
                              function: () {
                                Get.to(() => EditImage(),
                                    transition: Transition.rightToLeft);
                                Get.delete<ProfilePageController>();
                              },
                            )
                          ],
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
