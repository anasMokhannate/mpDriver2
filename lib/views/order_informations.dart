// ignore_for_file: must_be_immutable, library_prefixes

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/components/drawer.dart';
import 'package:motopickupdriver/controllers/order_informations.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/rate_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/models/order.dart' as orderModel;
import '../utils/queries.dart';
import '../utils/services.dart';
import 'home_page.dart';

class OrderInformations extends StatelessWidget {
  OrderInformations({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScoop(context),
      child: SafeArea(
        child: GetBuilder<OrderInformationsController>(
          init: OrderInformationsController(),
          builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: scaffold,
            key: _key,
            appBar: !controller.isTrue.value
                ? AppBar(
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
                      onTap: () async {
                        _key.currentState!.openDrawer();
                        await getCurrentUser().then((value) async {
                          controller.userBase = value;
                          await saveCurrentUser(controller.userBase!);
                        });
                      },
                      child: Icon(
                        Boxicons.bx_grid_alt,
                        color: primary,
                        size: 35.h,
                      ),
                    ),
                    toolbarHeight: 80.h,
                    title: Image.asset(
                      'assets/images/logoMoto_colored.png',
                      height: 50.h,
                    ),
                    actions: [
                      FlutterSwitch(
                        width: 70.w,
                        height: 40.h,
                        valueFontSize: 15.0,
                        activeColor: primary,
                        toggleSize: 30.0,
                        value: controller.isOnline,
                        borderRadius: 30.0,
                        padding: 5.0,
                        showOnOff: false,
                        onToggle: (val) {
                          controller.isOnline = !controller.isOnline;
                          controller.goOnline();
                          controller.update();
                        },
                      ),
                      15.horizontalSpace,
                    ],
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
            drawer: NavigationDrawerWidget(
              currentUser: controller.userBase,
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
                : controller.isOnline
                    ? Column(
                        children: [
                          GetBuilder<OrderInformationsController>(
                            builder: (value) => Expanded(
                              child: GoogleMap(
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                initialCameraPosition: controller.kGooglePlex!,
                                markers: controller.markers,
                                compassEnabled: false,
                                polylines: controller.polylines,
                                onMapCreated: (onMapCreated) {
                                  // controller.mapController = onMapCreated;
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Wrap(
                              children: [
                                Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("mp_orders")
                                        .where("order_id",
                                            isEqualTo: controller
                                                .userBase!.currentOrderDriver)
                                        .snapshots(),
                                    builder: (ctx,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        print('no dataaa');
                                        return Container();
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.docs.isNotEmpty) {
                                        // controller.orderStatus =
                                        //     'customer_accepted';
                                        // controller.getOrderStatus();

                                        print(
                                            "zzz status ${controller.orderStatus}");

                                        // TODO: he relevant error-causing widget was
                                        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>
                                        // order_informations.dart:145
                                        // When the exception was thrown, this was the stack
                                        if (snapshot.data!.docs.isEmpty) {
                                          Get.to(() => HomePage());
                                        }
                                        // if (snapshot.data!.docs.isEmpty) {
                                        //   Get.to(() => const HomePage());
                                        // }
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            snapshot.data!.docs.first;

                                        controller.orderStatus =
                                            documentSnapshot["status"];
                                        // final driver =
                                        //     documentSnapshot["driver"] ?? "";
                                        if (documentSnapshot["driver"] !=
                                            null) {
                                          controller.driverId =
                                              documentSnapshot["driver"]["uid"];
                                        } else {
                                          controller.driverId = "";
                                        }
                                        // controller.driverId = driver.uid ?? "";

                                        controller.startlatitude =
                                            documentSnapshot[
                                                        "order_pickup_location"]
                                                    ['geopoint']
                                                .latitude;
                                        controller.startlongitude =
                                            documentSnapshot[
                                                        "order_pickup_location"]
                                                    ['geopoint']
                                                .longitude;
                                        controller
                                            .endlatitude = documentSnapshot[
                                                    "order_arrival_location"]
                                                ['geopoint']
                                            .latitude;
                                        controller
                                            .endlongitude = documentSnapshot[
                                                    "order_arrival_location"]
                                                ['geopoint']
                                            .longitude;

                                        controller.setRoad(
                                            controller.startlatitude,
                                            controller.startlongitude,
                                            controller.endlatitude,
                                            controller.endlongitude);

                                        // controller.drawPolyline(
                                        //     LatLng(controller.startlatitude!,
                                        //         controller.startlongitude!),
                                        //     LatLng(controller.endlatitude!,
                                        //         controller.endlongitude!));

                                        // controller.markers.add(
                                        //   Marker(
                                        //     markerId: const MarkerId('id-1'),
                                        //     icon: controller.startIcon!,
                                        //     position: LatLng(
                                        //       controller.startlatitude!,
                                        //       controller.startlongitude!,
                                        //     ),
                                        //   ),
                                        // );
                                        // controller.markers.add(
                                        //   Marker(
                                        //     markerId: const MarkerId('id-1'),
                                        //     icon: controller.endIcon!,
                                        //     position: LatLng(
                                        //       controller.endlatitude!,
                                        //       controller.endlongitude!,
                                        //     ),
                                        //   ),
                                        // );

                                        print(
                                            "zzz orderId ${documentSnapshot['order_id']}");
                                        controller.ttime = double.parse(
                                                        documentSnapshot[
                                                            'nbre_km_depart_destination']) /
                                                    50 <
                                                1
                                            ? double.parse(documentSnapshot[
                                                    'nbre_km_depart_destination']) /
                                                50 *
                                                60
                                            : double.parse(documentSnapshot[
                                                    'nbre_km_depart_destination']) /
                                                50;
                                        String ttimeText = double.parse(
                                                        documentSnapshot[
                                                            'nbre_km_depart_destination']) /
                                                    50 <
                                                1
                                            ? "${controller.ttime.toStringAsFixed(1)} minutes"
                                            : "${controller.ttime.toStringAsFixed(1)} heures";

                                        // return Text(
                                        //     "data ${controller.order.orderId}");

                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Wrap(
                                            children: [
                                              Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      20.verticalSpace,
                                                      // Container(
                                                      //   height: 5.h,
                                                      //   width: 220.w,
                                                      //   decoration:
                                                      //       BoxDecoration(
                                                      //     color: Colors.grey,
                                                      //     borderRadius:
                                                      //         BorderRadius
                                                      //             .circular(
                                                      //                 360),
                                                      //   ),
                                                      // ),
                                                      // 20.verticalSpace,
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 45.w,
                                                              height: 45.w,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.r),
                                                                child: Image
                                                                    .network(
                                                                  documentSnapshot[
                                                                          'customer']
                                                                      [
                                                                      'profile_picture'],
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                            10.horizontalSpace,
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  documentSnapshot[
                                                                          'customer']
                                                                      [
                                                                      'full_name'],
                                                                  style:
                                                                      bodyTextStyle,
                                                                ),
                                                                Text(
                                                                  documentSnapshot['order_type']
                                                                              .toString() !=
                                                                          "0"
                                                                      ? "Voyage"
                                                                      : "Course",
                                                                  style:
                                                                      bodyTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              height: 45.h,
                                                              width: 45.h,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          6.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  50,
                                                                ),
                                                              ),
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  String
                                                                      customerUid =
                                                                      "";

                                                                  var docSnapshot = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'mp_orders')
                                                                      .doc(documentSnapshot[
                                                                          "order_id"])
                                                                      .get();
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    Map<String,
                                                                            dynamic>?
                                                                        data =
                                                                        docSnapshot
                                                                            .data();
                                                                    customerUid =
                                                                        data!["customer"]
                                                                            [
                                                                            'uid'];
                                                                  }
                                                                  String
                                                                      phoneNo =
                                                                      "";
                                                                  docSnapshot = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'mp_users')
                                                                      .doc(
                                                                          customerUid)
                                                                      .get();
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    Map<String,
                                                                            dynamic>?
                                                                        data =
                                                                        docSnapshot
                                                                            .data();
                                                                    phoneNo = data![
                                                                        'phone_number'];
                                                                  }

                                                                  await FlutterPhoneDirectCaller
                                                                      .callNumber(
                                                                          phoneNo);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Boxicons
                                                                      .bx_phone_call,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: primary,
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 45.h,
                                                              width: 45.h,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          6.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  50,
                                                                ),
                                                              ),
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  String
                                                                      customerUid =
                                                                      "";

                                                                  var docSnapshot = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'mp_orders')
                                                                      .doc(documentSnapshot[
                                                                          "order_id"])
                                                                      .get();
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    Map<String,
                                                                            dynamic>?
                                                                        data =
                                                                        docSnapshot
                                                                            .data();
                                                                    customerUid =
                                                                        data!["customer"]
                                                                            [
                                                                            'uid'];

                                                                    print(
                                                                        'haaa ');

                                                                    String
                                                                        phoneNo =
                                                                        "";
                                                                    docSnapshot = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'mp_users')
                                                                        .doc(
                                                                            customerUid)
                                                                        .get();
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      Map<String,
                                                                              dynamic>?
                                                                          data =
                                                                          docSnapshot
                                                                              .data();
                                                                      phoneNo =
                                                                          data!["customer"]
                                                                              [
                                                                              'phone_number'];

                                                                      print(
                                                                          "haaa $phoneNo");
                                                                      launchUrl(
                                                                          Uri.parse(
                                                                              "https://wa.me/$phoneNo"));
                                                                    }
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Boxicons
                                                                      .bx_message_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: primary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      20.verticalSpace,
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Boxicons
                                                                      .bx_dollar,
                                                                  color:
                                                                      primary,
                                                                ),
                                                                10.horizontalSpace,
                                                                Text(
                                                                  '${documentSnapshot['order_purchase_amount']} MAD',
                                                                  style:
                                                                      bodyTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                            20.horizontalSpace,
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Boxicons
                                                                      .bxs_map,
                                                                  color:
                                                                      primary,
                                                                ),
                                                                10.horizontalSpace,
                                                                Text(
                                                                  '${documentSnapshot['nbre_km_depart_destination']} Km   ($ttimeText)',
                                                                  style:
                                                                      bodyTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      20.verticalSpace,

                                                      //TODO: is canceled by customer
                                                      documentSnapshot[
                                                              'is_canceled_by_customer']
                                                          ? InkWell(
                                                              onTap: () {
                                                                controller
                                                                        .startCourse =
                                                                    false;
                                                                controller
                                                                        .isWithOrder =
                                                                    false;
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'mp_users')
                                                                    .doc(controller
                                                                        .userBase!
                                                                        .uid)
                                                                    .update({
                                                                  "current_order_driver":
                                                                      null
                                                                });
                                                                controller
                                                                        .isOnOrder =
                                                                    false;
                                                                controller
                                                                    .markers
                                                                    .clear();
                                                                controller
                                                                    .polylines
                                                                    .clear();
                                                                // controller.stopTimer();
                                                                controller
                                                                    .update();

                                                                Get.offAll(() =>
                                                                    HomePage());
                                                              },
                                                              child: Container(
                                                                height: 55.h,
                                                                width: 260.w,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360),
                                                                ),
                                                                child: Text(
                                                                  'Client a annulé la commande',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.sp,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        "LatoSemiBold",
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          // test on driver_accepted
                                                          : controller.orderStatus ==
                                                                      'driver_accepted' ||
                                                                  controller
                                                                          .orderStatus ==
                                                                      'customer_accepted'
                                                              ? Column(
                                                                  children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          if (documentSnapshot[
                                                                              'is_planned']) {
                                                                            print("zzz1");
                                                                            controller.startCourse =
                                                                                false;
                                                                            controller.isOnOrder =
                                                                                false;
                                                                            controller.isWithOrder =
                                                                                false;

                                                                            documentSnapshot['order_type'].toString() != "0"
                                                                                ? FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                    "current_order_driver": null,
                                                                                    "driver_planned_trip": FieldValue.increment(1)
                                                                                  })
                                                                                : FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                    "current_order_driver": null,
                                                                                    "driver_planned_delivery": FieldValue.increment(1)
                                                                                  });
                                                                            controller.markers.clear();
                                                                            controller.polylines.clear();
                                                                            controller.update();
                                                                            Get.offAll(() =>
                                                                                HomePage());

                                                                            String
                                                                                customerFcm =
                                                                                documentSnapshot["customer"]["curr_fcm"];
                                                                            String
                                                                                driverFcm =
                                                                                documentSnapshot["driver"]["curr_fcm"];

                                                                            sendPlanifiedNotification([
                                                                              customerFcm
                                                                            ], "voyage", "Voyage va commencer dans 30 min",
                                                                                DateTime.parse(documentSnapshot['order_pickup_time']));
                                                                            sendPlanifiedNotification([
                                                                              driverFcm
                                                                            ], "voyage", "Voyage va commencer dans 30 min",
                                                                                DateTime.parse(documentSnapshot['order_pickup_time']));
                                                                            controller.markers.clear();
                                                                            controller.polylines.clear();
                                                                            controller.getUserLocation();
                                                                            await controller.getWithOrder();
                                                                            controller.update();
                                                                          } else {
                                                                            print("zzzzz");

                                                                            print("zzzz ${documentSnapshot["driver"]['uid']} ${controller.driverId}");
                                                                            // if (controller.driverId == controller.userBase!.uid) {
                                                                            if (controller.orderStatus ==
                                                                                'customer_accepted') {
                                                                              controller.startCourse = true;
                                                                              controller.startLocationUpdates(documentSnapshot['order_id']);
                                                                              await FirebaseFirestore.instance.collection("mp_orders").doc(controller.userBase!.currentOrderDriver).update({
                                                                                'status': 'driver_coming'
                                                                              });

                                                                              // controller.markers
                                                                              //     .clear();
                                                                              // controller.polylines
                                                                              //     .clear();
                                                                              // controller
                                                                              //     .getUserLocation();
                                                                              await controller.getWithOrder();
                                                                              //controller.isWithOrder = true;
                                                                              controller.update();
                                                                            }
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              55.h,
                                                                          width:
                                                                              320.w,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                // controller.driverId == controller.userBase!.uid
                                                                                controller.orderStatus == 'customer_accepted' ? primary : Colors.grey.withOpacity(0.4),
                                                                            borderRadius:
                                                                                BorderRadius.circular(360),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            // controller.driverId == controller.userBase!.uid ?
                                                                            controller.orderStatus == 'customer_accepted'
                                                                                ? 'Continuer'
                                                                                : 'En attente',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.sp,
                                                                              color: Colors.white,
                                                                              fontFamily: "LatoSemiBold",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (controller
                                                                              .orderStatus ==
                                                                          'customer_accepted')
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 20.h,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                controller.isOnOrder = false;
                                                                                controller.isWithOrder = false;
                                                                                documentSnapshot['order_type'].toString() != "0"
                                                                                    ? FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                        // "current_order_driver": null,
                                                                                        "driver_cancelled_trip": FieldValue.increment(1)
                                                                                      })
                                                                                    : FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                        // "current_order_driver": null,
                                                                                        "driver_cancelled_delivery": FieldValue.increment(1)
                                                                                      });

                                                                                String fcm = documentSnapshot["customer"]["curr_fcm"];

                                                                                sendNotification([
                                                                                  fcm
                                                                                ], "voyage annulé", "Le chauffeur a annulé le voyage");
                                                                                await annulerOrder(
                                                                                  controller.userBase!,
                                                                                  orderModel.Order.fromJson(documentSnapshot.data()! as Map<String, dynamic>),
                                                                                );
                                                                                Get.to(() => HomePage(), transition: Transition.rightToLeft);
                                                                                // controller
                                                                                //     .markers
                                                                                //     .clear();
                                                                                // controller
                                                                                //     .polylines
                                                                                //     .clear();

                                                                                controller.getUserLocation();
                                                                                await controller.getWithOrder();
                                                                                // controller.stopTimer();

                                                                                Get.offAll(() => HomePage());
                                                                                controller.update();
                                                                              },
                                                                              child: Container(
                                                                                height: 55.h,
                                                                                width: 320.w,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.red,
                                                                                  borderRadius: BorderRadius.circular(360),
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
                                                                            )
                                                                          ],
                                                                        ),
                                                                    ])
                                                              : controller.orderStatus ==
                                                                      'driver_coming'
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            fcm =
                                                                            documentSnapshot["customer"]["curr_fcm"];

                                                                        newOne() async {
                                                                          double
                                                                              distancee =
                                                                              double.parse(documentSnapshot['nbre_km_depart_destination']) / 50;
                                                                          print(controller
                                                                              .ttime
                                                                              .toInt());
                                                                          sendNotification([
                                                                            fcm
                                                                          ], "voyage a commencée",
                                                                              "votre chauffeur arrivera dans ${double.parse(documentSnapshot['nbre_km_depart_destination']) / 50 < 1 ? "${controller.ttime.toStringAsFixed(1)} minutes" : "${controller.ttime.toStringAsFixed(1)} heures"}  ");
                                                                          plannedNotif(
                                                                              [
                                                                                fcm
                                                                              ],
                                                                              "Votre Motopickup vous attend.",
                                                                              "",
                                                                              DateTime.now().add(Duration(minutes: controller.ttime.toInt())));
                                                                          // double.parse(documentSnapshot['nbre_km_depart_destination']) /
                                                                          //             50 <
                                                                          //         1
                                                                          // ? plannedNotif(
                                                                          //     [
                                                                          //         fcm
                                                                          //       ],
                                                                          //     "Votre Motopickup vous attend.",
                                                                          //     " ",
                                                                          //     DateTime.now().add(Duration(
                                                                          //         minutes: ttime
                                                                          //             .toInt())))
                                                                          // : plannedNotif(
                                                                          //     [
                                                                          //         fcm
                                                                          //       ],
                                                                          //     "Votre Motopickup vous attend.",
                                                                          //     " ",
                                                                          //     DateTime.now().add(Duration(
                                                                          //         hours:
                                                                          //             ttime.toInt())));
                                                                          // await updateStatusOrder(
                                                                          //     controller.orderID);
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  "mp_orders")
                                                                              .doc(controller
                                                                                  .userBase!.currentOrderDriver)
                                                                              .update({
                                                                            'status':
                                                                                'driver_is_here'
                                                                          });
                                                                          // controller
                                                                          //     .updateMyLocation(
                                                                          //         documentSnapshot["order_id"]);
                                                                          controller
                                                                              .update();
                                                                        }

                                                                        newOne();

                                                                        controller
                                                                            .update();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            55.h,
                                                                        width:
                                                                            260.w,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(360),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          documentSnapshot['order_type'] != 0
                                                                              ? 'Commencez le voyage'
                                                                              : 'Commencer la course',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                "LatoSemiBold",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : controller.orderStatus ==
                                                                          'driver_is_here'
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            String
                                                                                fcm =
                                                                                documentSnapshot["customer"]["curr_fcm"];

                                                                            paiment(context,
                                                                                () async {
                                                                              // sendNotification(
                                                                              //     [fcm],
                                                                              //     "voyage est finis",
                                                                              //     "au revoir");
                                                                              // updateSuccedOrder(controller.orderID);
                                                                              await FirebaseFirestore.instance.collection("mp_orders").doc(controller.userBase!.currentOrderDriver).update({
                                                                                'status': 'in_rating'
                                                                              });
                                                                              controller.startCourse = false;
                                                                              controller.isOnOrder = false;
                                                                              controller.isWithOrder = false;

                                                                              await controller.getWithOrder();
                                                                              controller.markers.clear();
                                                                              controller.polylines.clear();
                                                                              await SessionManager().set("order_id", controller.userBase!.currentOrderDriver);
                                                                              await SessionManager().set("distance", Geolocator.distanceBetween(documentSnapshot["order_pickup_location"]['geopoint'].latitude, documentSnapshot["order_pickup_location"]['geopoint'].longitude, controller.latitude!, controller.longitude!));
                                                                              // controller
                                                                              //     .stopTimer();
                                                                              if (controller.positionStream != null) {
                                                                                controller.positionStream!.cancel();
                                                                              }

                                                                              Get.delete<OrderInformations>();
                                                                              Get.offAll(() => RateClient());
                                                                            });
                                                                            controller.update();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                55.h,
                                                                            width:
                                                                                260.w,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.circular(360),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              documentSnapshot['order_type'] != 0 ? 'Finir le voyage' : 'Finir la course',
                                                                              style: TextStyle(
                                                                                fontSize: 15.sp,
                                                                                color: Colors.white,
                                                                                fontFamily: "LatoSemiBold",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.w),
                                          child: InkWell(
                                            onTap: () {
                                              controller.startCourse = false;
                                              controller.isWithOrder = false;
                                              FirebaseFirestore.instance
                                                  .collection('mp_users')
                                                  .doc(controller.userBase!.uid)
                                                  .update({
                                                "current_order_driver": null
                                              });
                                              controller.isOnOrder = false;
                                              controller.markers.clear();
                                              controller.polylines.clear();
                                              // controller.stopTimer();
                                              controller.update();

                                              Get.offAll(() => HomePage());
                                            },
                                            child: Container(
                                              height: 55.h,
                                              width: 260.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              child: Text(
                                                'Client a annulé la commande',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.white,
                                                  fontFamily: "LatoSemiBold",
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          240.verticalSpace,
                          Center(
                            child: Text(
                              'Vous êtes hors ligne',
                              style: primaryHeadlineTextStyle,
                            ),
                          ),
                          20.verticalSpace,
                          Text(
                            'Passez en ligne pour recevoir vos commandes',
                            style: bodyTextStyle,
                          ),
                          40.verticalSpace,
                          OutlineButton(
                            text: 'Passer en ligne',
                            function: () {
                              controller.isOnline = true;
                              controller.goOnline();
                              controller.update();
                            },
                          ),
                          const Spacer(),
                          SupportButton(mode: dark),
                          80.verticalSpace,
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
