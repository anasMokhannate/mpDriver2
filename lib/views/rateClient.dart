// ignore_for_file: prefer_const_constructors

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/controllers/rateClietnController.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/home_page.dart';

class RateClient extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  RateClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: InkWell(
        //   onTap: () => Get.back(),
        //   child: Icon(
        //     Boxicons.bx_arrow_back,
        //     color: primary,
        //     size: 30.h,
        //   ),
        // ),
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
        child: GetBuilder<RateClientController>(
            init: RateClientController(),
            builder: (controller) {
              return controller.loading.value
                  ? Center(
                      child: SizedBox(
                      width: 225.w,
                      child: const LoadingIndicator(
                          indicatorType: Indicator.ballScaleMultiple,
                          colors: [primary],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black),
                    ))
                  : Column(
                      children: [
                        Center(
                            child: Text(
                          'Notez votre expérience',
                          style: primaryHeadlineTextStyle,
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 27.h, bottom: 10.h),
                          width: 103.w,
                          height: 103.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: Image.network(
                              controller.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.fullname),
                            17.horizontalSpace,
                            Text(controller.client_stars.toString())
                          ],
                        ),
                        74.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                controller.rating_stars >= 1
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                controller.updateRating(1);
                              },
                              color: primary,
                            ),
                            IconButton(
                              icon: Icon(
                                controller.rating_stars >= 2
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                controller.updateRating(2);
                              },
                              color: primary,
                            ),
                            IconButton(
                              icon: Icon(
                                controller.rating_stars >= 3
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                controller.updateRating(3);
                              },
                              color: primary,
                            ),
                            IconButton(
                              icon: Icon(
                                controller.rating_stars >= 4
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                controller.updateRating(4);
                              },
                              color: primary,
                            ),
                            IconButton(
                              icon: Icon(
                                controller.rating_stars >= 5
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                controller.updateRating(5);
                              },
                              color: primary,
                            ),
                          ],
                        ),
                        33.21.verticalSpace,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextFormField(
                            minLines:
                                6, // any number you need (It works as the rows for the textarea)
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: controller.inputController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                    borderSide: BorderSide(color: border)),
                                hintText: 'Laisser un commentaire...'),
                          ),
                        ),
                        45.verticalSpace,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: PrimaryButton(
                                  text: 'Valider',
                                  function: () {
                                    controller.sendFeedBack();
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              23.w, 26.h, 23.w, 0),
                                          title: Text(
                                            'Signaler un incident',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          content: SizedBox(
                                            width: 294.w,
                                            height: 118.h,
                                            child: TextFormField(
                                              controller: controller
                                                  .reportInputController,
                                              maxLines: 6,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "Que s'est-il passé ?",
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: border),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r))),
                                            ),
                                          ),
                                          actions: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Boxicons
                                                          .bx_help_circle),
                                                      5.horizontalSpace,
                                                      Text('Support')
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                            'Annuler',
                                                            style: TextStyle(
                                                                color: border),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await controller
                                                                .reportClient();
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                            'Envoyer',
                                                            style: TextStyle(
                                                                color: primary),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  height: 65.h,
                                  width: 159.5.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(360),
                                      border: Border.all(color: Colors.red)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Signaler',
                                    style: TextStyle(
                                        fontFamily: 'LatoBold',
                                        fontSize: 14.sp,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
