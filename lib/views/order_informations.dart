// ignore_for_file: must_be_immutable

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
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/rate_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/services.dart';

class OrderInformations extends StatefulWidget {
  const OrderInformations({Key? key}) : super(key: key);

  @override
  State<OrderInformations> createState() => _OrderInformationsState();
}

class _OrderInformationsState extends State<OrderInformations> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var controller = Get.put(OrderInformationsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScoop(context),
      child: SafeArea(
        child: GetBuilder<OrderInformationsController>(
          init: OrderInformationsController(),
          builder: (value) => Scaffold(
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
                          print(
                              "this is the total orders${controller.userBase!.totalOrders}");
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
                        value: controller.status,
                        borderRadius: 30.0,
                        padding: 5.0,
                        showOnOff: false,
                        onToggle: (val) {
                          controller.status = !controller.status;
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
                : controller.status
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
                                            isEqualTo: controller.orderID)
                                        .snapshots(),
                                    builder: (ctx,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Text('');
                                      } else {
                                        print("zzz ${controller.driverId}");
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            snapshot.data!.docs[0];

                                        controller.driverId =
                                            documentSnapshot["driver"]['uid'] ??
                                                "";

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
                                            "zzz ${documentSnapshot['order_id']}");
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
                                                                          'orders')
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
                                                                  "is_on_order":
                                                                      false
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

                                                                // Get.offAll(() =>
                                                                //     const HomePage());
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
                                                          : controller
                                                                  .isWithOrder
                                                              ? InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    List<dynamic>
                                                                        fcm =
                                                                        documentSnapshot["customer"]
                                                                            [
                                                                            "fcmList"];

                                                                    newOne() async {
                                                                      double
                                                                          distancee =
                                                                          double.parse(documentSnapshot['nbre_km_depart_destination']) /
                                                                              50;
                                                                      print(controller
                                                                          .ttime
                                                                          .toInt());
                                                                      sendNotification(
                                                                          fcm
                                                                              .map((item) => item.toString())
                                                                              .toList(),
                                                                          "voyage a commencée",
                                                                          "votre chauffeur arrivera dans ${double.parse(documentSnapshot['nbre_km_depart_destination']) / 50 < 1 ? "${controller.ttime.toStringAsFixed(1)} minutes" : "${controller.ttime.toStringAsFixed(1)} heures"}  ");
                                                                      plannedNotif(
                                                                          fcm
                                                                              .map((item) => item.toString())
                                                                              .toList(),
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
                                                                      await updateStatusOrder(
                                                                          controller
                                                                              .orderID);
                                                                      // controller
                                                                      //     .updateMyLocation(
                                                                      //         documentSnapshot["order_id"]);
                                                                      controller
                                                                          .update();
                                                                    }

                                                                    documentSnapshot['is_start'] ==
                                                                            false
                                                                        ? newOne()
                                                                        : paiment(
                                                                            context,
                                                                            () async {
                                                                            // sendNotification(
                                                                            //     [fcm],
                                                                            //     "voyage est finis",
                                                                            //     "au revoir");
                                                                            updateSuccedOrder(controller.orderID);
                                                                            controller.startCourse =
                                                                                false;
                                                                            controller.isOnOrder =
                                                                                false;
                                                                            controller.isWithOrder =
                                                                                false;
                                                                            FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                              "is_on_order": false
                                                                            });
                                                                            await controller.getWithOrder();
                                                                            controller.markers.clear();
                                                                            controller.polylines.clear();
                                                                            await SessionManager().set("order_id",
                                                                                controller.orderID);
                                                                            await SessionManager().set("distance",
                                                                                Geolocator.distanceBetween(documentSnapshot["order_pickup_location"]['geopoint'].latitude, documentSnapshot["order_pickup_location"]['geopoint'].longitude, controller.latitude!, controller.longitude!));
                                                                            // controller
                                                                            //     .stopTimer();
                                                                            Get.delete<OrderInformations>();
                                                                            Get.offAll(() =>
                                                                                RateClient());
                                                                          });
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
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: documentSnapshot['is_start'] ==
                                                                              false
                                                                          ? primary
                                                                          : Colors
                                                                              .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              360),
                                                                    ),
                                                                    child: Text(
                                                                      documentSnapshot['is_start'] ==
                                                                              false
                                                                          ? documentSnapshot['order_type'] != 0
                                                                              ? 'Commencez le voyage'
                                                                              : 'Commencer la course'
                                                                          : documentSnapshot['order_type'] != 0
                                                                              ? 'Finir le voyage'
                                                                              : 'Finir la course',
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
                                                              : Column(
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
                                                                                    "is_on_order": false,
                                                                                    "driver_planned_trip": FieldValue.increment(1)
                                                                                  })
                                                                                : FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                    "is_on_order": false,
                                                                                    "driver_planned_delivery": FieldValue.increment(1)
                                                                                  });
                                                                            controller.markers.clear();
                                                                            controller.polylines.clear();
                                                                            controller.update();
                                                                            // Get.offAll(() =>
                                                                            //     const HomePage());

                                                                            List<dynamic>
                                                                                customerFcm =
                                                                                documentSnapshot["customer"]["fcmList"];
                                                                            List<dynamic>
                                                                                driverFcm =
                                                                                documentSnapshot["driver"]["fcmList"];

                                                                            sendPlanifiedNotification(
                                                                                customerFcm.map((item) => item.toString()).toList(),
                                                                                "voyage",
                                                                                "Voyage va commencer dans 30 min",
                                                                                DateTime.parse(documentSnapshot['order_pickup_time']));
                                                                            sendPlanifiedNotification(
                                                                                driverFcm.map((item) => item.toString()).toList(),
                                                                                "voyage",
                                                                                "Voyage va commencer dans 30 min",
                                                                                DateTime.parse(documentSnapshot['order_pickup_time']));
                                                                            controller.markers.clear();
                                                                            controller.polylines.clear();
                                                                            controller.getUserLocation();
                                                                            await controller.getWithOrder();
                                                                            controller.update();
                                                                          } else {
                                                                            print("zzzzz");

                                                                            print("zzzz ${documentSnapshot["driver"]['uid']} ${controller.driverId}");
                                                                            if (controller.driverId ==
                                                                                controller.userBase!.uid) {
                                                                              controller.startCourse = true;

                                                                              // controller.markers
                                                                              //     .clear();
                                                                              // controller.polylines
                                                                              //     .clear();
                                                                              // controller
                                                                              //     .getUserLocation();
                                                                              await controller.getWithOrder();
                                                                              controller.isWithOrder = true;
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
                                                                            color: controller.driverId == controller.userBase!.uid
                                                                                ? primary
                                                                                : Colors.grey.withOpacity(0.4),
                                                                            borderRadius:
                                                                                BorderRadius.circular(360),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            controller.driverId == controller.userBase!.uid
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
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          controller.isOnOrder =
                                                                              false;
                                                                          controller.isWithOrder =
                                                                              false;
                                                                          documentSnapshot['order_type'].toString() != "0"
                                                                              ? FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                  "is_on_order": false,
                                                                                  "driver_cancelled_trip": FieldValue.increment(1)
                                                                                })
                                                                              : FirebaseFirestore.instance.collection('mp_users').doc(controller.userBase!.uid).update({
                                                                                  "is_on_order": false,
                                                                                  "driver_cancelled_delivery": FieldValue.increment(1)
                                                                                });

                                                                          List<dynamic>
                                                                              fcm =
                                                                              documentSnapshot["customer"]["fcmList"];

                                                                          sendNotification(
                                                                              fcm.map((item) => item.toString()).toList(),
                                                                              "voyage annulé",
                                                                              "Le chauffeur a annulé le voyage");
                                                                          // refuserOrder(
                                                                          //     controller.userBase!,
                                                                          //     controller.orderID);
                                                                          controller
                                                                              .markers
                                                                              .clear();
                                                                          controller
                                                                              .polylines
                                                                              .clear();

                                                                          controller
                                                                              .getUserLocation();
                                                                          await controller
                                                                              .getWithOrder();
                                                                          // controller.stopTimer();
                                                                          controller
                                                                              .update();
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
                                                                                Colors.red,
                                                                            borderRadius:
                                                                                BorderRadius.circular(360),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            'Annuler',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.sp,
                                                                              color: Colors.white,
                                                                              fontFamily: "LatoSemiBold",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),

                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                    ],
                                                  )),
                                            ],
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
                              controller.status = true;
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
