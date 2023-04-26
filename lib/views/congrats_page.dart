// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/controllers/congrats_page.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/home_page.dart';

class Congrats extends StatelessWidget {
  Congrats({Key? key}) : super(key: key);
  var controller = Get.put(CongratsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<CongratsController>(
        init: CongratsController(),
        builder: (value) => Scaffold(
          backgroundColor: scaffold,
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
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("mp_users")
                      .doc(controller.userBase!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        'No Data...',
                      );
                    } else {
                      var data = snapshot.data as DocumentSnapshot;
                      if (!data['is_activated_account']) {
                        return Column(
                          children: [
                            45.verticalSpace,
                            Center(
                              child: Text(
                                'Félicitations !',
                                style: primaryHeadlineTextStyle,
                              ),
                            ),
                            35.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Bienvenue ${controller.userBase?.fullName} parmi la communauté Motopickup!',
                                textAlign: TextAlign.center,
                                style: bodyTextStyle,
                              ),
                            ),
                            35.verticalSpace,
                            Image.asset('assets/images/congrats.webp'),
                            35.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Nous vous remercions pour votre inscription. Notre équipe se chargera d’examiner et valider votre demande dans les meilleurs délais.',
                                textAlign: TextAlign.center,
                                style: bodyTextStyle,
                              ),
                            ),
                            40.verticalSpace,
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            45.verticalSpace,
                            Center(
                              child: Text(
                                'Félicitations !',
                                style: primaryHeadlineTextStyle,
                              ),
                            ),
                            35.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Bienvenue Ayoub Chahid parmi la communauté Motopickup!',
                                textAlign: TextAlign.center,
                                style: bodyTextStyle,
                              ),
                            ),
                            35.verticalSpace,
                            Image.asset('assets/images/congrats.webp'),
                            35.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Félicitations, votre compte a été vérifié, vous pouvez maintenant commencer votre voyage.',
                                textAlign: TextAlign.center,
                                style: bodyTextStyle,
                              ),
                            ),
                            40.verticalSpace,
                            PrimaryButton(
                              text: 'Continuer',
                              function: () async {
                                Get.offAll(() => const HomePage(),
                                    transition: Transition.rightToLeft);
                              },
                            )
                          ],
                        );
                      }
                    }
                  },
                ),
        ),
      ),
    );
  }
}
