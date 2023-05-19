// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/inputs.dart';
import 'package:motopickupdriver/controllers/completeYourProfile/verify_identity.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/utils/typography.dart';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({Key? key}) : super(key: key);

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  var controller = Get.put(VerifyIdentityController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<VerifyIdentityController>(
        init: VerifyIdentityController(),
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
                      'Confirmer votre identité',
                      style: primaryHeadlineTextStyle,
                    ),
                  ),
                  20.verticalSpace,
                  InkWell(
                    onTap: () {
                      controller.selectImageCard();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          height: 220.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.cardFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Boxicons.bxs_cloud_upload,
                                      color: light,
                                      size: 85.sp,
                                    ),
                                    5.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Text(
                                        "Téléchargez votre carte d'identité",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: light,
                                            fontFamily: 'LatoBold',
                                            fontSize: 14.sp),
                                      ),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.card!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GetBuilder<VerifyIdentityController>(
                    init: VerifyIdentityController(),
                    builder: (value) => InputDatePicker(
                      dateText: controller.cardExpire,
                      icon: Boxicons.bxs_calendar,
                      function: () => DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          controller.cardExpire =
                              DateFormat('yyyy-MM-dd').format(date).toString();

                          sendPlanifiedNotification(
                              [controller.userBase!.fcm],
                              'Expiration de votre carte d\'identité',
                              'Votre carte d\'identité expire le ${controller.cardExpire}',
                              DateTime.parse(controller.cardExpire));
                          controller.update();
                        },
                        currentTime: DateTime.now(),
                        locale: context.locale.toString() == 'fr'
                            ? LocaleType.fr
                            : LocaleType.ar,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      controller.selectImageLicence();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          height: 220.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.cardLicence == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Boxicons.bxs_cloud_upload,
                                      color: light,
                                      size: 85.sp,
                                    ),
                                    5.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Text(
                                        "Téléchargez votre permis de conduite",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: light,
                                            fontFamily: 'LatoBold',
                                            fontSize: 14.sp),
                                      ),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.licence!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GetBuilder<VerifyIdentityController>(
                    init: VerifyIdentityController(),
                    builder: (value) => InputDatePicker(
                      dateText: controller.licenceExpire,
                      icon: Boxicons.bxs_calendar,
                      function: () => DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          controller.licenceExpire =
                              DateFormat('yyyy-MM-dd').format(date).toString();
                          sendPlanifiedNotification(
                              [controller.userBase!.fcm],
                              'Expiration de votre permis de conduite',
                              'Votre permis de conduite expire le ${controller.licenceExpire}',
                              DateTime.parse(controller.licenceExpire));
                          controller.update();
                        },
                        currentTime: DateTime.now(),
                        locale: context.locale.toString() == 'fr'
                            ? LocaleType.fr
                            : LocaleType.ar,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      controller.selectImageAssurance();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          height: 220.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.cardAssurance == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Boxicons.bxs_cloud_upload,
                                      color: light,
                                      size: 85.sp,
                                    ),
                                    5.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Text(
                                        "Téléchargez votre assurance",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: light,
                                            fontFamily: 'LatoBold',
                                            fontSize: 14.sp),
                                      ),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.assurance!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GetBuilder<VerifyIdentityController>(
                    init: VerifyIdentityController(),
                    builder: (value) => InputDatePicker(
                      dateText: controller.assuranceExpire,
                      icon: Boxicons.bxs_calendar,
                      function: () => DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          controller.assuranceExpire =
                              DateFormat('yyyy-MM-dd').format(date).toString();
                          sendPlanifiedNotification(
                            [controller.userBase!.fcm!],
                            'Expiration de votre assurance',
                            'Votre assurance expire le ${controller.assuranceExpire}',
                            DateTime.parse(controller.assuranceExpire),
                          );
                          controller.update();
                        },
                        currentTime: DateTime.now(),
                        locale: context.locale.toString() == 'fr'
                            ? LocaleType.fr
                            : LocaleType.ar,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      controller.selectImageGrise();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          height: 220.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.cardGrise == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Boxicons.bxs_cloud_upload,
                                      color: light,
                                      size: 85.sp,
                                    ),
                                    5.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Text(
                                        "Téléchargez votre carte grise",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: light,
                                            fontFamily: 'LatoBold',
                                            fontSize: 14.sp),
                                      ),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.grise!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GetBuilder<VerifyIdentityController>(
                    init: VerifyIdentityController(),
                    builder: (value) => InputDatePicker(
                      dateText: controller.griseExpire,
                      icon: Boxicons.bxs_calendar,
                      function: () => DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          controller.griseExpire =
                              DateFormat('yyyy-MM-dd').format(date).toString();
                          sendPlanifiedNotification(
                              [controller.userBase!.fcm!],
                              'Expiration de votre carte grise',
                              'Votre carte grise expire le ${controller.griseExpire}',
                              DateTime.parse(controller.griseExpire));
                          controller.update();
                        },
                        currentTime: DateTime.now(),
                        locale: context.locale.toString() == 'fr'
                            ? LocaleType.fr
                            : LocaleType.ar,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      controller.selectImageAnthropometrique();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          height: 220.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.cardAnthropometrique == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Boxicons.bxs_cloud_upload,
                                      color: light,
                                      size: 85.sp,
                                    ),
                                    5.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Text(
                                        "Téléchargez votre carte Anthropometrique",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: light,
                                            fontFamily: 'LatoBold',
                                            fontSize: 14.sp),
                                      ),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.anthropometrique!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  PrimaryButton(
                    text: 'Continuer',
                    function: () async {
                      await controller.validat(context).then((value) {
                        if (value) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return GetBuilder<VerifyIdentityController>(
                                init: VerifyIdentityController(),
                                builder: (value) => Wrap(
                                  children: [
                                    Container(
                                      height: 20.h,
                                      color: Colors.white,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 225.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: dark.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(360),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20.h,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        'Je veux utiliser cette application en tant que:',
                                        style: bodyTextStyle,
                                      ),
                                    ),
                                    // Container(
                                    //   height: 20.h,
                                    //   color: Colors.white,
                                    // ),
                                    // InkWell(
                                    //   onTap: () {
                                    //     // controller.isCoursier =
                                    //     //     !controller.isCoursier;
                                    //     // controller.update();
                                    //   },
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 20.w),
                                    //     child: Container(
                                    //       height: 60.h,
                                    //       width:
                                    //           MediaQuery.of(context).size.width,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(12),
                                    //         border: Border.all(
                                    //           color: primary,
                                    //         ),
                                    //       ),
                                    //       child: Row(
                                    //         children: [
                                    //           15.horizontalSpace,
                                    //           Container(
                                    //             height: 40.h,
                                    //             width: 40.h,
                                    //             decoration: BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.circular(10),
                                    //               border: Border.all(
                                    //                 color: primary,
                                    //               ),
                                    //             ),
                                    //             child: const Icon(
                                    //               Boxicons.bx_check,
                                    //               color: // controller.isCoursier
                                    //                   //? primary
                                    //                   //:
                                    //                   Colors.transparent,
                                    //             ),
                                    //           ),
                                    //           15.horizontalSpace,
                                    //           Text(
                                    //             'Coursier',
                                    //             style: alertDialogTitle,
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      height: 20.h,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.isDriver.toggle();
                                        controller.update();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Container(
                                          height: 60.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: primary,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              15.horizontalSpace,
                                              Container(
                                                height: 40.h,
                                                width: 40.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: primary,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Boxicons.bx_check,
                                                  color:
                                                      controller.isDriver.value
                                                          ? primary
                                                          : Colors.transparent,
                                                ),
                                              ),
                                              15.horizontalSpace,
                                              Text(
                                                'Chauffeur',
                                                style: alertDialogTitle,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20.h,
                                      color: Colors.white,
                                    ),
                                    PrimaryButton(
                                      text: 'Terminer',
                                      function: () async {
                                        Navigator.pop(context);
                                        controller.submit(context);
                                      },
                                    ),
                                    Container(
                                      height: 40.h,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      });
                    },
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
