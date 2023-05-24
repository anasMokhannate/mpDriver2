// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/controllers/order_information.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/rate_client.dart';

class OrderInformation extends StatelessWidget {
  dynamic order;
  OrderInformation({Key? key, this.order}) : super(key: key);
  var controller = Get.put(OrderInformationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<OrderInformationController>(
        init: OrderInformationController(),
        builder: (value) => Scaffold(
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
          body: controller.isTrue.value
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('mp_orders')
                      .where('order_id', isEqualTo: controller.orderId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 225.w,
                          child: const LoadingIndicator(
                              indicatorType: Indicator.ballScaleMultiple,
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
                    } else {
                      List<DocumentSnapshot> documentSnapshot =
                          snapshot.data!.docs;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 65.w,
                                  height: 65.w,
                                  decoration: BoxDecoration(
                                    color: documentSnapshot[0]['status'] ==
                                            "order_cancelled"
                                        ? Colors.red.withOpacity(0.2)
                                        : documentSnapshot[0]['status'] ==
                                                    "order_finished" ||
                                                documentSnapshot[0]['status'] ==
                                                    "in_rating"
                                            ? primary.withOpacity(0.2)
                                            : documentSnapshot[0]['is_planned']
                                                ? const Color(0xAAF1E6C2)
                                                : primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    // documentSnapshot[0]['order_type']
                                    //             .toString() ==
                                    //         '1'
                                    //     ?
                                    FontAwesomeIcons.motorcycle,
                                    // : Boxicons.bx_package,
                                    color: documentSnapshot[0]['status'] ==
                                            "order_cancelled"
                                        ? Colors.red
                                        : documentSnapshot[0]['status'] ==
                                                    "order_finished" ||
                                                documentSnapshot[0]['status'] ==
                                                    "in_rating"
                                            ? primary
                                            : documentSnapshot[0]['is_planned']
                                                ? const Color.fromARGB(
                                                    170, 147, 140, 118)
                                                : primary,
                                  ),
                                ),
                                20.horizontalSpace,
                                Text(
                                  documentSnapshot[0]['status'] ==
                                          "order_cancelled"
                                      ? "Commande annulé"
                                      : documentSnapshot[0]['status'] ==
                                              "order_finished"
                                          ? "Commande terminée"
                                          : documentSnapshot[0]['is_planned'] &&
                                                  !documentSnapshot[0]
                                                      ['is_finished']
                                              ? "Plannifier pour ${documentSnapshot[0]['order_pickup_time']}"
                                              : "Commande terminée",
                                  style: bodyTextStyle,
                                )
                              ],
                            ),
                            20.verticalSpace,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Boxicons.bxs_circle,
                                              size: 10.h,
                                              color: Colors.grey,
                                            ),
                                            Container(
                                              height: 25.h,
                                              width: 2.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360)),
                                            ),
                                            Icon(
                                              Boxicons.bxs_circle,
                                              size: 10.h,
                                            ),
                                          ],
                                        ),
                                        10.horizontalSpace,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 250.w,
                                              child: Text(
                                                documentSnapshot[0]
                                                        ['address_from']
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: bodyTextStyle,
                                              ),
                                            ),
                                            10.verticalSpace,
                                            SizedBox(
                                              width: 250.w,
                                              child: Text(
                                                documentSnapshot[0]
                                                        ['address_to']
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: bodyTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    20.verticalSpace,
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Boxicons.bx_time),
                                        10.horizontalSpace,
                                        Text(
                                          'Date  : ${documentSnapshot[0]['order_pickup_time']}',
                                          textAlign: TextAlign.start,
                                          style: bodyTextStyle,
                                        ),
                                        // Text(
                                        //   controller.time,
                                        //   textAlign: TextAlign.start,
                                        //   style: bodyTextStyle,
                                        // )
                                      ],
                                    ),
                                    20.verticalSpace,
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Boxicons.bx_money),
                                        10.horizontalSpace,
                                        Text(
                                          'Prix : ${documentSnapshot[0]['order_purchase_amount']} MAD',
                                          textAlign: TextAlign.start,
                                          style: bodyTextStyle,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            20.verticalSpace,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: border),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 50.h,
                                          width: 50.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            child: Image.network(
                                              documentSnapshot[0]['customer']
                                                  ['profile_picture'],
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documentSnapshot[0]['customer']
                                                  ['full_name'],
                                              style: bodyTextStyle,
                                            ),
                                            5.verticalSpace,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  controller.startsmean >= 1
                                                      ? Boxicons.bxs_star
                                                      : Boxicons.bx_star,
                                                  color: primary,
                                                  size: 15.sp,
                                                ),
                                                Icon(
                                                  controller.startsmean >= 2
                                                      ? Boxicons.bxs_star
                                                      : Boxicons.bx_star,
                                                  color: primary,
                                                  size: 15.sp,
                                                ),
                                                Icon(
                                                  controller.startsmean >= 3
                                                      ? Boxicons.bxs_star
                                                      : Boxicons.bx_star,
                                                  color: primary,
                                                  size: 15.sp,
                                                ),
                                                Icon(
                                                  controller.startsmean >= 4
                                                      ? Boxicons.bxs_star
                                                      : Boxicons.bx_star,
                                                  color: primary,
                                                  size: 15.sp,
                                                ),
                                                Icon(
                                                  controller.startsmean >= 5
                                                      ? Boxicons.bxs_star
                                                      : Boxicons.bx_star,
                                                  color: primary,
                                                  size: 15.sp,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        if (documentSnapshot[0]['status'] !=
                                            "order_finished")
                                          Container(
                                            height: 55.w,
                                            width: 55.w,
                                            decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Boxicons.bx_phone,
                                                size: 20.sp,
                                                color: light,
                                              ),
                                              onPressed: () {
                                                FlutterPhoneDirectCaller
                                                    .callNumber(controller
                                                        .clientNumber);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            documentSnapshot[0]['is_planned'] &&
                                    documentSnapshot[0]['is_finished'] != true
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20.h),
                                        child: PrimaryButton(
                                          text: documentSnapshot[0]['status'] ==
                                                  "customer_accepted"
                                              ? 'Commencer le voyage'
                                              : 'Finir le Voyage',
                                          function: () async {
                                            if (documentSnapshot[0]['status'] !=
                                                "driver_is_here") {
                                              await FirebaseFirestore.instance
                                                  .collection('mp_users')
                                                  .doc(documentSnapshot[0]
                                                      ['driver.uid'])
                                                  .update(({
                                                    'current_order_driver':
                                                        order['order_id'],
                                                  }));
                                              await FirebaseFirestore.instance
                                                  .collection('mp_users')
                                                  .doc(documentSnapshot[0]
                                                      ['customer.uid'])
                                                  .update(({
                                                    'current_order_customer':
                                                        order['order_id'],
                                                  }));
                                              String fcm = documentSnapshot[0]
                                                  ["customer.curr_fcm"];

                                              sendNotification(
                                                  [fcm],
                                                  "Voyage a commencé",
                                                  "Le chauffeur est en route");
                                              controller.contrr.isWithOrder =
                                                  true;
                                              await FirebaseFirestore.instance
                                                  .collection('mp_orders')
                                                  .doc(order['order_id'])
                                                  .update(({
                                                    'status': "driver_is_here",
                                                  }));
                                              controller.contrr.update();
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('mp_orders')
                                                  .doc(order['order_id'])
                                                  .update(({
                                                    'status': "in_rating",
                                                    'is_finished': true,
                                                  }));
                                              controller.userBase!
                                                      .driverTotalOrders =
                                                  controller.userBase!
                                                          .driverTotalOrders! +
                                                      1;
                                              await FirebaseFirestore.instance
                                                  .collection('mp_users')
                                                  .doc(documentSnapshot[0]
                                                      ['driver.uid'])
                                                  .update(({
                                                    'driver_total_orders':
                                                        FieldValue.increment(1),
                                                  }));

                                              String fcm = documentSnapshot[0]
                                                  ["customer.curr_fcm"];
                                              sendNotification(
                                                  [fcm],
                                                  "Voyage Terminé",
                                                  "au revoir");
                                              controller.contrr.isWithOrder =
                                                  false;
                                              controller.contrr.update();
                                              await SessionManager().set(
                                                  "order_id",
                                                  order['order_id']);
                                              Get.offAll(() => RateClient());
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20.h),
                                        child: InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('mp_orders')
                                                .doc(order['order_id'])
                                                .update(({
                                                  'is_cancelled_by_driver':
                                                      true,
                                                  'status': "order_cancelled",
                                                }));
                                            documentSnapshot[0]['order_type']
                                                        .toString() !=
                                                    "0"
                                                ? FirebaseFirestore.instance
                                                    .collection('mp_users')
                                                    .doc(documentSnapshot[0]
                                                        ['driver.uid'])
                                                    .update(({
                                                      'current_order_driver':
                                                          null,
                                                      "driver_cancelled_trip":
                                                          FieldValue.increment(
                                                              1)
                                                    }))
                                                : FirebaseFirestore.instance
                                                    .collection('mp_users')
                                                    .doc(documentSnapshot[0]
                                                        ['driver.uid'])
                                                    .update(({
                                                      "driver_cancelled_delivery":
                                                          FieldValue.increment(
                                                              1),
                                                      'current_order_driver':
                                                          null,
                                                    }));
                                            String fcm = documentSnapshot[0]
                                                ["customer.curr_fcm"];

                                            sendNotification(
                                                [fcm],
                                                "voyage annulé",
                                                "Le chauffeur a annulé le voyage");
                                            // refuserOrder(widget.drive, order.uid);
                                          },
                                          child: Container(
                                            height: 55.h,
                                            width: 250.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                            ),
                                            child: Text(
                                              'Annuler',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.white,
                                                fontFamily: "LatoSemiBold",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }
                  },
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
