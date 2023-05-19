// ignore_for_file: avoid_print, must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/components/cards.dart';
import 'package:motopickupdriver/controllers/my_command.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/order_information.dart';

class MyCommand extends StatelessWidget {
  MyCommand({Key? key}) : super(key: key);
  var controller = Get.put(MyCommandController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MyCommandController>(
        init: MyCommandController(),
        builder: (value) => Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                print("object");

                Get.back();
              },
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
          body: controller.isTrue.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Mes commandes',
                        style: primaryHeadlineTextStyle,
                      ),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Container(
                            height: 120.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              color: primary,
                              border: Border.all(color: primary, width: 15.w),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Boxicons.bx_money,
                                  color: Colors.amberAccent,
                                  size: 30.h,
                                ),
                                Text(
                                  //TODO: controller.userBase!.total_paid ?
                                  "${controller.userBase!.orderTotalAmount ?? 0} MAD",
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: Colors.amberAccent,
                                    fontFamily: "LatoSemiBold",
                                  ),
                                ),
                                Text(
                                  'Montant total',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: light,
                                    fontFamily: "LatoSemiBold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 120.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              color: primary,
                              border: Border.all(color: primary, width: 15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Boxicons.bx_package,
                                  color: light,
                                  size: 30.h,
                                ),
                                Text(
                                  controller.userBase!.totalOrders.toString(),
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: light,
                                    fontFamily: "LatoSemiBold",
                                  ),
                                ),
                                Text(
                                  'Total des course',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: light,
                                    fontFamily: "LatoSemiBold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          TypeOrder(
                            isActive: controller.isActiveOne,
                            text: 'Historique',
                            function: () {
                              controller.isActiveOne = false;
                              controller.isActiveTwo = true;
                              controller.update();
                            },
                          ),
                          const Spacer(),
                          TypeOrder(
                            isActive: controller.isActiveTwo,
                            text: 'À venir',
                            function: () {
                              controller.isActiveTwo = false;
                              controller.isActiveOne = true;
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    !controller.isActiveOne
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('mp_orders')
                                .where('driver_uid',
                                    isEqualTo: controller.userBase!.uid)
                                .where("status", whereIn: [0, 1]).snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    width: 225.w,
                                    child: const LoadingIndicator(
                                        indicatorType:
                                            Indicator.ballScaleMultiple,
                                        colors: [primary],
                                        strokeWidth: 2,
                                        backgroundColor: Colors.transparent,
                                        pathBackgroundColor: Colors.black),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/empty.png',
                                        width: 310.w,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Il n'y a pas encore de commandes",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: primary,
                                          height: 1.2,
                                          fontFamily: "LatoSemiBold",
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/empty.png',
                                        width: 310.w,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Il n'y a pas encore de commandes",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: primary,
                                          height: 1.2,
                                          fontFamily: "LatoSemiBold",
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasData) {
                                List<DocumentSnapshot> documentSnapshot =
                                    snapshot.data!.docs;
                                documentSnapshot = documentSnapshot.toList();
                                documentSnapshot.sort(
                                  (a, b) {
                                    return b['order_pickup_time']
                                        .compareTo(a['order_pickup_time']);
                                  },
                                );

                                return SizedBox(
                                  height: 386.h,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CommandCard(
                                          date: documentSnapshot[index]
                                              ['order_pickup_time'],
                                          prix: snapshot
                                              .data!
                                              .docs[index]
                                                  ['order_purchase_amount']
                                              .toString(),
                                          from: documentSnapshot[index]
                                              ['address_from'],
                                          to: documentSnapshot[index]
                                              ['address_to'],
                                          status: documentSnapshot[index]
                                              ['status'],
                                          onTap: () {
                                            Get.to(() => OrderInformation(),
                                                transition:
                                                    Transition.rightToLeft,
                                                arguments: [
                                                  documentSnapshot[index]
                                                          ['order_id']
                                                      .toString()
                                                ]);
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Container();
                                      },
                                      itemCount: documentSnapshot.length),
                                );
                              } else {
                                return const Text('');
                              }
                            },
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .where('driver_uid',
                                    isEqualTo: controller.userBase!.uid)
                                .where('status', isEqualTo: 3)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    width: 225.w,
                                    child: const LoadingIndicator(
                                        indicatorType:
                                            Indicator.ballScaleMultiple,
                                        colors: [primary],
                                        strokeWidth: 2,
                                        backgroundColor: Colors.transparent,
                                        pathBackgroundColor: Colors.black),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/empty.png',
                                        width: 310.w,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Il n'y a pas encore de commandes",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: primary,
                                          height: 1.2,
                                          fontFamily: "LatoSemiBold",
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/empty.png',
                                        width: 310.w,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Il n'y a pas encore de commandes",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: primary,
                                          height: 1.2,
                                          fontFamily: "LatoSemiBold",
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasData) {
                                List<DocumentSnapshot> documentSnapshot =
                                    snapshot.data!.docs
                                        .where((element) =>
                                            element['order_pickup_time']
                                                .compareTo(DateFormat(
                                                        "yyyy-MM-dd HH:mm")
                                                    .format(DateTime.now())) >=
                                            0)
                                        .toList();
                                documentSnapshot.sort(
                                  (a, b) {
                                    return b['order_pickup_time']
                                        .compareTo(a['order_pickup_time']);
                                  },
                                );
                                return SizedBox(
                                  height: 386.h,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CommandCard(
                                          date: documentSnapshot[index]
                                              ['order_pickup_time'],
                                          prix: snapshot
                                              .data!
                                              .docs[index]
                                                  ['order_purchase_amount']
                                              .toString(),
                                          from: documentSnapshot[index]
                                              ['address_from'],
                                          to: documentSnapshot[index]
                                              ['address_to'],
                                          status: documentSnapshot[index]
                                              ['status'],
                                          onTap: () {
                                            Get.to(
                                                () => OrderInformation(
                                                      order: documentSnapshot[
                                                          index],
                                                    ),
                                                transition:
                                                    Transition.rightToLeft,
                                                arguments: [
                                                  documentSnapshot[index]
                                                          ['order_id']
                                                      .toString()
                                                ]);
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Container();
                                      },
                                      itemCount: documentSnapshot.length),
                                );
                              } else {
                                return const Text('');
                              }
                            },
                          ),
                  ],
                )
              : Center(
                  child: SizedBox(
                    width: 225.w,
                    child: const LoadingIndicator(
                        indicatorType: Indicator.ballScaleMultiple,
                        colors: [primary],
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.black),
                  ),
                ),
        ),
      ),
    );
  }
}
