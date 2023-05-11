// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:motopickupdriver/components/cards.dart';
import 'package:motopickupdriver/components/drawer.dart';
import 'package:motopickupdriver/controllers/home_page.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

import '../utils/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScoop(context),
      child: SafeArea(
        child: GetBuilder<HomePageController>(
          init: HomePageController(),
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
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('mp_orders')
                            .where('drivers_concerned',
                                arrayContains: controller.userBase!.uid)
                            .snapshots(),

                        // controller.geo!
                        //     .collection(
                        //         collectionRef: FirebaseFirestore.instance
                        //             .collection("mp_orders"))
                        //     .within(
                        //         center: controller.center!,
                        //         radius: 10000,
                        //         field: "order_pickup_location",
                        //         strictMode: true),

                        // stream: FirebaseFirestore.instance
                        //     .collection("orders")
                        //     // .where('order_city',
                        //     //     isEqualTo: controller.city)
                        //     // .where('is_succeed', isEqualTo: false)
                        //     // .where('is_canceled_by_customer',
                        //     //     isEqualTo: false)
                        //     // .where('created_at',
                        //     //     isEqualTo:
                        //     //         DateFormat('yyyy-MM-dd HH')
                        //     //             .format(DateTime.now()))
                        //     .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          print("abc ${snapshot.toString()}");
                          if (!snapshot.hasData) {
                            // return const Text('hasntData');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            if (snapshot.data!.docs.isEmpty) {
                              // return const Text('isEmpty');
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (!documentSnapshot['drivers_declined']
                                          .contains(controller.userBase!.uid) &&
                                      !documentSnapshot['drivers_accepted']
                                          .contains(
                                              (controller.userBase!.uid))) {
                                    print(documentSnapshot['customer']['note']);
                                    double distance =
                                        Geolocator.distanceBetween(
                                            documentSnapshot[
                                                        "order_pickup_location"]
                                                    ["geopoint"]
                                                .latitude,
                                            documentSnapshot[
                                                        "order_pickup_location"]
                                                    ["geopoint"]
                                                .longitude,
                                            controller.latitude!,
                                            controller.longitude!);
                                    //TODO: < instead of >
                                    // if ((distance / 1000) >
                                    //         documentSnapshot['km_radius'] &&
                                    //     controller.isWithOrder == false) {
                                    controller.stars =
                                        documentSnapshot['customer']['note'] /
                                            documentSnapshot['customer']
                                                ['total_orders'];
                                    // controller.showCard=true;
                                    // controller.update();
                                    return OrdersCard(
                                      status: 1,
                                      photo: documentSnapshot["customer"]
                                          ["profile_picture"],
                                      username: documentSnapshot["customer"]
                                          ["full_name"],
                                      orderType: documentSnapshot["order_type"]
                                          .toString(),
                                      from: documentSnapshot["address_from"],
                                      to: documentSnapshot["address_to"],
                                      idOrder: documentSnapshot["order_id"],
                                      drive: controller.userBase!,
                                      distance:
                                          (distance / 1000).toStringAsFixed(2),
                                      stars: controller.stars,
                                      accepte: () async {
                                        FirebaseFirestore.instance
                                            .collection('mp_users')
                                            .doc(controller.userBase!.uid)
                                            .update({"is_on_order": true});

                                        FirebaseFirestore.instance
                                            .collection("mp_orders")
                                            .doc(documentSnapshot["order_id"])
                                            .update({
                                          "drivers_accepted":
                                              FieldValue.arrayUnion([
                                            controller.userBase!.toJson()
                                          ])
                                        });

                                        // controller.showCard=false;
                                        // controller.update();
                                        // String fcm =
                                        //     documentSnapshot["customer"]
                                        //         ["current_fcm"];
                                        // sendNotification([
                                        //   fcm
                                        // ], "Votre commande est en attente de confirmation",
                                        //     "");
                                        controller.isOnOrder = true;
                                        controller.isWithOrder = true;
                                        // String fcmDriver =
                                        //     await SessionManager()
                                        //         .get('user_fcm');
                                        // FirebaseFirestore.instance
                                        //     .collection('mp_orders')
                                        //     .doc(documentSnapshot[
                                        //         "order_id"])
                                        //     .update(({
                                        //       "driver_fcm": fcmDriver,
                                        //     }));

                                        // controller.setRoad(
                                        //     documentSnapshot[
                                        //             "order_pickup_location"]
                                        //         ["latitude"],
                                        //     documentSnapshot[
                                        //             "order_pickup_location"]
                                        //         ["longitude"],
                                        //     documentSnapshot[
                                        //             "order_arrival_location"]
                                        //         ["latitude"],
                                        //     documentSnapshot[
                                        //             "order_arrival_location"]
                                        //         ["longitude"]);
                                        // addDriverToOrder(
                                        //     controller.userBase!,
                                        //     documentSnapshot[
                                        //         "order_id"]);
                                        controller.update();
                                      },
                                    );
                                    // }
                                  } else {
                                    return const Text('B');
                                  }
                                },
                              );
                            }
                          }
                        },
                      )

                    //===================================================== Map =====================================================

                    // ? Stack(
                    //     children: [
                    //       GetBuilder<HomePageController>(
                    //         builder: (value) => GoogleMap(
                    //           myLocationEnabled: true,
                    //           mapType: MapType.normal,
                    //           initialCameraPosition: controller.kGooglePlex!,
                    //           markers: controller.markers,
                    //           compassEnabled: false,
                    //           polylines: controller.polylines,
                    //           onMapCreated: (onMapCreated) {
                    //             // controller.mapController = onMapCreated;
                    //           },
                    //         ),
                    //       ),
                    //       if (!controller.isOnOrder)
                    //         Positioned(
                    //           top: 200.h,
                    //           child: Container(
                    //             width: MediaQuery.of(context).size.width,
                    //             color: Colors.transparent,
                    //             child: StreamBuilder(
                    //               stream: FirebaseFirestore.instance
                    //                   .collection("orders")
                    //                   .where('order_city',
                    //                       isEqualTo: controller.city)
                    //                   .where('is_succeed', isEqualTo: false)
                    //                   .where('is_canceled_by_customer',
                    //                       isEqualTo: false)
                    //                   .where('created_at',
                    //                       isEqualTo: DateFormat('yyyy-MM-dd HH')
                    //                           .format(DateTime.now()))
                    //                   .snapshots(),
                    //               builder: (context,
                    //                   AsyncSnapshot<QuerySnapshot> snapshot) {
                    //                 print(snapshot.toString());
                    //                 if (!snapshot.hasData) {
                    //                   return const Text('');
                    //                 } else {
                    //                   if (snapshot.data!.docs.isEmpty) {
                    //                     return const Text('');
                    //                   } else {
                    //                     return ListView.builder(
                    //                       shrinkWrap: true,
                    //                       physics:
                    //                           const BouncingScrollPhysics(),
                    //                       itemCount: snapshot.data!.docs.length,
                    //                       itemBuilder: (context, index) {
                    //                         final DocumentSnapshot
                    //                             documentSnapshot =
                    //                             snapshot.data!.docs[index];
                    //                         if (!documentSnapshot[
                    //                                     'drivers_declined']
                    //                                 .contains(controller
                    //                                     .userBase!.uid) &&
                    //                             !documentSnapshot[
                    //                                     'drivers_accepted']
                    //                                 .contains((controller
                    //                                     .userBase!.uid))) {
                    //                           print(documentSnapshot['user']
                    //                               ['customer_note']);
                    //                           double distance =
                    //                               Geolocator.distanceBetween(
                    //                                   documentSnapshot[
                    //                                           "order_pickup_location"]
                    //                                       ['latitude'],
                    //                                   documentSnapshot[
                    //                                           "order_pickup_location"]
                    //                                       ['longitude'],
                    //                                   controller.latitude!,
                    //                                   controller.longtitude!);
                    //                           if ((distance / 1000) <
                    //                                   documentSnapshot[
                    //                                       'km_radius'] &&
                    //                               controller.isWithOrder ==
                    //                                   false) {
                    //                             controller
                    //                                 .stars = documentSnapshot[
                    //                                         'user']
                    //                                     ['customer_note'] /
                    //                                 documentSnapshot['user'][
                    //                                     'customer_total_orders'];
                    //                             // controller.showCard=true;
                    //                             // controller.update();
                    //                             return OrdersCard(
                    //                               status: documentSnapshot[
                    //                                   "status"],
                    //                               photo:
                    //                                   documentSnapshot["user"]
                    //                                       ["customer_picture"],
                    //                               username: documentSnapshot[
                    //                                       "user"]
                    //                                   ["customer_full_name"],
                    //                               orderType: documentSnapshot[
                    //                                       "order_type"]
                    //                                   .toString(),
                    //                               from: documentSnapshot[
                    //                                   "address_from"],
                    //                               to: documentSnapshot[
                    //                                   "address_to"],
                    //                               idOrder: documentSnapshot[
                    //                                   "order_id"],
                    //                               drive: controller.userBase!,
                    //                               distance: (distance / 1000)
                    //                                   .toStringAsFixed(2),
                    //                               stars: controller.stars,
                    //                               accepte: () async {
                    //                                 // controller.showCard=false;
                    //                                 // controller.update();
                    //                                 String fcm =
                    //                                     documentSnapshot[
                    //                                         "customer_fcm"];
                    //                                 sendNotification([
                    //                                   fcm
                    //                                 ], "Votre commande est en attente de confirmation",
                    //                                     "");
                    //                                 controller.isOnOrder = true;
                    //                                 controller.isWithOrder =
                    //                                     true;
                    //                                 String fcmDriver =
                    //                                     await SessionManager()
                    //                                         .get('driver_fcm');
                    //                                 FirebaseFirestore.instance
                    //                                     .collection('orders')
                    //                                     .doc(documentSnapshot[
                    //                                         "order_id"])
                    //                                     .update(({
                    //                                       "driver_fcm":
                    //                                           fcmDriver,
                    //                                     }));
                    //                                 FirebaseFirestore.instance
                    //                                     .collection('drivers')
                    //                                     .doc(controller
                    //                                         .userBase!.uid)
                    //                                     .update({
                    //                                   "is_on_order": true
                    //                                 });
                    //                                 controller.setRoad(
                    //                                     documentSnapshot[
                    //                                             "order_pickup_location"]
                    //                                         ["latitude"],
                    //                                     documentSnapshot[
                    //                                             "order_pickup_location"]
                    //                                         ["longitude"],
                    //                                     documentSnapshot[
                    //                                             "order_arrival_location"]
                    //                                         ["latitude"],
                    //                                     documentSnapshot[
                    //                                             "order_arrival_location"]
                    //                                         ["longitude"]);
                    //                                 // addDriverToOrder(
                    //                                 //     controller.userBase!,
                    //                                 //     documentSnapshot[
                    //                                 //         "order_id"]);
                    //                                 controller.orderID =
                    //                                     documentSnapshot[
                    //                                         "order_id"];
                    //                                 controller.update();
                    //                               },
                    //                             );
                    //                           } else {
                    //                             return const Text('');
                    //                           }
                    //                         } else {
                    //                           return const Text('');
                    //                         }
                    //                       },
                    //                     );
                    //                   }
                    //                 }
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       if (controller.isOnOrder && !controller.startCourse)
                    //         Align(
                    //           alignment: Alignment.bottomCenter,
                    //           child: Wrap(
                    //             children: [
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                     color: Colors.white),
                    //                 child: StreamBuilder(
                    //                   stream: FirebaseFirestore.instance
                    //                       .collection("orders")
                    //                       .where("order_id",
                    //                           isEqualTo: controller.orderID)
                    //                       .snapshots(),
                    //                   builder: (ctx,
                    //                       AsyncSnapshot<QuerySnapshot>
                    //                           snapshot) {
                    //                     if (!snapshot.hasData) {
                    //                       return const Text('');
                    //                     } else {
                    //                       final DocumentSnapshot
                    //                           documentSnapshot =
                    //                           snapshot.data!.docs[0];
                    //                       controller.ttime = double.parse(
                    //                                       documentSnapshot[
                    //                                           'nbre_km_depart_destination']) /
                    //                                   50 <
                    //                               1
                    //                           ? double.parse(documentSnapshot[
                    //                                   'nbre_km_depart_destination']) /
                    //                               50 *
                    //                               60
                    //                           : double.parse(documentSnapshot[
                    //                                   'nbre_km_depart_destination']) /
                    //                               50;
                    //                       String ttimeText = double.parse(
                    //                                       documentSnapshot[
                    //                                           'nbre_km_depart_destination']) /
                    //                                   50 <
                    //                               1
                    //                           ? "${controller.ttime.toStringAsFixed(1)} minutes"
                    //                           : "${controller.ttime.toStringAsFixed(1)} heures";

                    //                       return Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.center,
                    //                         children: [
                    //                           20.verticalSpace,
                    //                           Container(
                    //                             height: 5.h,
                    //                             width: 220.w,
                    //                             decoration: BoxDecoration(
                    //                               color: Colors.grey,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       360),
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           Padding(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 20.w),
                    //                             child: Row(
                    //                               children: [
                    //                                 SizedBox(
                    //                                   width: 45.w,
                    //                                   height: 45.w,
                    //                                   child: ClipRRect(
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(50.r),
                    //                                     child: Image.network(
                    //                                       documentSnapshot[
                    //                                               'user'][
                    //                                           'customer_picture'],
                    //                                       fit: BoxFit.fill,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 10.horizontalSpace,
                    //                                 Column(
                    //                                   crossAxisAlignment:
                    //                                       CrossAxisAlignment
                    //                                           .start,
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .spaceBetween,
                    //                                   children: [
                    //                                     Text(
                    //                                       documentSnapshot[
                    //                                               'user'][
                    //                                           'customer_full_name'],
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                     Text(
                    //                                       documentSnapshot[
                    //                                                       'order_type']
                    //                                                   .toString() !=
                    //                                               "0"
                    //                                           ? "Voyage"
                    //                                           : "Course",
                    //                                       style: bodyTextStyle,
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                                 const Spacer(),
                    //                                 Container(
                    //                                   height: 45.h,
                    //                                   width: 45.h,
                    //                                   margin: EdgeInsets.only(
                    //                                       left: 6.w),
                    //                                   decoration: BoxDecoration(
                    //                                     color: primary,
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(
                    //                                       50,
                    //                                     ),
                    //                                   ),
                    //                                   child: IconButton(
                    //                                     onPressed: () async {
                    //                                       String customerUid =
                    //                                           "";

                    //                                       var docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'orders')
                    //                                               .doc(controller
                    //                                                   .orderID)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         customerUid = data![
                    //                                             'customer_uid'];
                    //                                       }
                    //                                       String phoneNo = "";
                    //                                       docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'users')
                    //                                               .doc(
                    //                                                   customerUid)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         phoneNo = data![
                    //                                             'customer_phone_number'];
                    //                                       }

                    //                                       await FlutterPhoneDirectCaller
                    //                                           .callNumber(
                    //                                               phoneNo);
                    //                                     },
                    //                                     icon: const Icon(
                    //                                       Boxicons
                    //                                           .bx_phone_call,
                    //                                       color: Colors.white,
                    //                                     ),
                    //                                     color: primary,
                    //                                   ),
                    //                                 ),
                    //                                 Container(
                    //                                   height: 45.h,
                    //                                   width: 45.h,
                    //                                   margin: EdgeInsets.only(
                    //                                       left: 6.w),
                    //                                   decoration: BoxDecoration(
                    //                                     color: primary,
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(
                    //                                       50,
                    //                                     ),
                    //                                   ),
                    //                                   child: IconButton(
                    //                                     onPressed: () async {
                    //                                       String customerUid =
                    //                                           "";

                    //                                       var docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'orders')
                    //                                               .doc(controller
                    //                                                   .orderID)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         customerUid = data![
                    //                                             'customer_uid'];
                    //                                       }
                    //                                       String phoneNo = "";
                    //                                       docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'users')
                    //                                               .doc(
                    //                                                   customerUid)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         phoneNo = data![
                    //                                             'customer_phone_number'];
                    //                                       }

                    //                                       launch(
                    //                                           "https://wa.me/$phoneNo");
                    //                                     },
                    //                                     icon: const Icon(
                    //                                       Boxicons
                    //                                           .bx_message_rounded,
                    //                                       color: Colors.white,
                    //                                     ),
                    //                                     color: primary,
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           Padding(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 20.w),
                    //                             child: Row(
                    //                               children: [
                    //                                 Row(
                    //                                   children: [
                    //                                     const Icon(
                    //                                       Boxicons.bx_dollar,
                    //                                       color: primary,
                    //                                     ),
                    //                                     10.horizontalSpace,
                    //                                     Text(
                    //                                       '${documentSnapshot['order_purchase_amount']} MAD',
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                                 20.horizontalSpace,
                    //                                 Row(
                    //                                   children: [
                    //                                     const Icon(
                    //                                       Boxicons.bxs_map,
                    //                                       color: primary,
                    //                                     ),
                    //                                     10.horizontalSpace,
                    //                                     Text(
                    //                                       '${documentSnapshot['nbre_km_depart_destination']} Km   ($ttimeText)',
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           documentSnapshot[
                    //                                   'is_canceled_by_customer']
                    //                               ? InkWell(
                    //                                   onTap: () {
                    //                                     controller.startCourse =
                    //                                         false;
                    //                                     controller.isWithOrder =
                    //                                         false;
                    //                                     FirebaseFirestore
                    //                                         .instance
                    //                                         .collection(
                    //                                             'drivers')
                    //                                         .doc(controller
                    //                                             .userBase!.uid)
                    //                                         .update({
                    //                                       "is_on_order": false
                    //                                     });
                    //                                     controller.isOnOrder =
                    //                                         false;
                    //                                     controller.markers
                    //                                         .clear();
                    //                                     controller.polylines
                    //                                         .clear();
                    //                                     controller.stopTimer();
                    //                                     controller.update();

                    //                                     // Get.offAll(() =>
                    //                                     //     const HomePage());
                    //                                   },
                    //                                   child: Container(
                    //                                     height: 55.h,
                    //                                     width: 260.w,
                    //                                     alignment:
                    //                                         Alignment.center,
                    //                                     decoration:
                    //                                         BoxDecoration(
                    //                                       color: Colors.red,
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   360),
                    //                                     ),
                    //                                     child: Text(
                    //                                       'Client a annulé la commande',
                    //                                       style: TextStyle(
                    //                                         fontSize: 15.sp,
                    //                                         color: Colors.white,
                    //                                         fontFamily:
                    //                                             "LatoSemiBold",
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 )
                    //                               : InkWell(
                    //                                   onTap: () async {
                    //                                     if (documentSnapshot[
                    //                                             'status'] ==
                    //                                         3) {
                    //                                       controller
                    //                                               .startCourse =
                    //                                           false;
                    //                                       controller.isOnOrder =
                    //                                           false;
                    //                                       controller
                    //                                               .isWithOrder =
                    //                                           false;

                    //                                       documentSnapshot[
                    //                                                       'order_type']
                    //                                                   .toString() !=
                    //                                               "0"
                    //                                           ? FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'drivers')
                    //                                               .doc(controller
                    //                                                   .userBase!
                    //                                                   .uid)
                    //                                               .update({
                    //                                               "is_on_order":
                    //                                                   false,
                    //                                               "driver_planned_trip":
                    //                                                   FieldValue
                    //                                                       .increment(
                    //                                                           1)
                    //                                             })
                    //                                           : FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'drivers')
                    //                                               .doc(controller
                    //                                                   .userBase!
                    //                                                   .uid)
                    //                                               .update({
                    //                                               "is_on_order":
                    //                                                   false,
                    //                                               "driver_planned_delivery":
                    //                                                   FieldValue
                    //                                                       .increment(
                    //                                                           1)
                    //                                             });
                    //                                       controller.markers
                    //                                           .clear();
                    //                                       controller.polylines
                    //                                           .clear();
                    //                                       controller.update();
                    //                                       // Get.offAll(() =>
                    //                                       //     const HomePage());

                    //                                       String customerFcm =
                    //                                           documentSnapshot[
                    //                                               "customer_fcm"];
                    //                                       String driverFcm =
                    //                                           documentSnapshot[
                    //                                               "driver_fcm"];

                    //                                       sendPlanifiedNotification(
                    //                                           [
                    //                                             customerFcm
                    //                                           ],
                    //                                           "voyage",
                    //                                           "Voyage va commencer dans 30 min",
                    //                                           DateTime.parse(
                    //                                               documentSnapshot[
                    //                                                   'order_pickup_time']));
                    //                                       sendPlanifiedNotification(
                    //                                           [
                    //                                             driverFcm
                    //                                           ],
                    //                                           "voyage",
                    //                                           "Voyage va commencer dans 30 min",
                    //                                           DateTime.parse(
                    //                                               documentSnapshot[
                    //                                                   'order_pickup_time']));
                    //                                       controller.markers
                    //                                           .clear();
                    //                                       controller.polylines
                    //                                           .clear();
                    //                                       controller
                    //                                           .getUserLocation();
                    //                                       await controller
                    //                                           .getWithOrder();
                    //                                       controller.update();
                    //                                     } else {
                    //                                       if (documentSnapshot[
                    //                                               'uid'] ==
                    //                                           controller
                    //                                               .userBase!
                    //                                               .uid) {
                    //                                         controller
                    //                                                 .startCourse =
                    //                                             true;

                    //                                         // controller.markers
                    //                                         //     .clear();
                    //                                         // controller.polylines
                    //                                         //     .clear();
                    //                                         // controller
                    //                                         //     .getUserLocation();
                    //                                         await controller
                    //                                             .getWithOrder();
                    //                                         controller.update();
                    //                                       }
                    //                                     }
                    //                                   },
                    //                                   child: Container(
                    //                                     height: 55.h,
                    //                                     width: 320.w,
                    //                                     alignment:
                    //                                         Alignment.center,
                    //                                     decoration:
                    //                                         BoxDecoration(
                    //                                       color: documentSnapshot[
                    //                                                   'uid'] ==
                    //                                               controller
                    //                                                   .userBase!
                    //                                                   .uid
                    //                                           ? primary
                    //                                           : Colors.grey
                    //                                               .withOpacity(
                    //                                                   0.4),
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   360),
                    //                                     ),
                    //                                     child: Text(
                    //                                       documentSnapshot[
                    //                                                   'uid'] ==
                    //                                               controller
                    //                                                   .userBase!
                    //                                                   .uid
                    //                                           ? 'Continuer'
                    //                                           : 'En attente',
                    //                                       style: TextStyle(
                    //                                         fontSize: 15.sp,
                    //                                         color: Colors.white,
                    //                                         fontFamily:
                    //                                             "LatoSemiBold",
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                           SizedBox(
                    //                             height: 20.h,
                    //                           ),
                    //                           InkWell(
                    //                             onTap: () async {
                    //                               controller.isOnOrder = false;
                    //                               controller.isWithOrder =
                    //                                   false;
                    //                               documentSnapshot['order_type']
                    //                                           .toString() !=
                    //                                       "0"
                    //                                   ? FirebaseFirestore
                    //                                       .instance
                    //                                       .collection('drivers')
                    //                                       .doc(controller
                    //                                           .userBase!.uid)
                    //                                       .update({
                    //                                       "is_on_order": false,
                    //                                       "driver_cancelled_trip":
                    //                                           FieldValue
                    //                                               .increment(1)
                    //                                     })
                    //                                   : FirebaseFirestore
                    //                                       .instance
                    //                                       .collection('drivers')
                    //                                       .doc(controller
                    //                                           .userBase!.uid)
                    //                                       .update({
                    //                                       "is_on_order": false,
                    //                                       "driver_cancelled_delivery":
                    //                                           FieldValue
                    //                                               .increment(1)
                    //                                     });

                    //                               String fcm = documentSnapshot[
                    //                                   "customer_fcm"];

                    //                               sendNotification(
                    //                                   [fcm],
                    //                                   "voyage annulé",
                    //                                   "Le chauffeur a annulé le voyage");
                    //                               // refuserOrder(
                    //                               //     controller.userBase!,
                    //                               //     controller.orderID);
                    //                               controller.markers.clear();
                    //                               controller.polylines.clear();

                    //                               controller.getUserLocation();
                    //                               await controller
                    //                                   .getWithOrder();
                    //                               controller.stopTimer();
                    //                               controller.update();
                    //                             },
                    //                             child: Container(
                    //                               height: 55.h,
                    //                               width: 320.w,
                    //                               alignment: Alignment.center,
                    //                               decoration: BoxDecoration(
                    //                                 color: Colors.red,
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         360),
                    //                               ),
                    //                               child: Text(
                    //                                 'Annuler',
                    //                                 style: TextStyle(
                    //                                   fontSize: 15.sp,
                    //                                   color: Colors.white,
                    //                                   fontFamily:
                    //                                       "LatoSemiBold",
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 20.h,
                    //                           ),
                    //                         ],
                    //                       );
                    //                     }
                    //                   },
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       if (controller.startCourse)
                    //         Align(
                    //           alignment: Alignment.bottomCenter,
                    //           child: Wrap(
                    //             children: [
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                     color: Colors.white),
                    //                 child: StreamBuilder(
                    //                   stream: FirebaseFirestore.instance
                    //                       .collection("orders")
                    //                       .where("order_id",
                    //                           isEqualTo: controller.orderID)
                    //                       .snapshots(),
                    //                   builder: (ctx,
                    //                       AsyncSnapshot<QuerySnapshot>
                    //                           snapshot) {
                    //                     if (!snapshot.hasData) {
                    //                       return const Text('');
                    //                     } else {
                    //                       final DocumentSnapshot
                    //                           documentSnapshot =
                    //                           snapshot.data!.docs[0];
                    //                       double ttime = double.parse(
                    //                                       documentSnapshot[
                    //                                           'nbre_km_depart_destination']) /
                    //                                   50 <
                    //                               1
                    //                           ? double.parse(documentSnapshot[
                    //                                   'nbre_km_depart_destination']) /
                    //                               50 *
                    //                               60
                    //                           : double.parse(documentSnapshot[
                    //                                   'nbre_km_depart_destination']) /
                    //                               50;
                    //                       String ttimeText = double.parse(
                    //                                       documentSnapshot[
                    //                                           'nbre_km_depart_destination']) /
                    //                                   50 <
                    //                               1
                    //                           ? "${ttime.toStringAsFixed(1)} minutes"
                    //                           : "${ttime.toStringAsFixed(1)} heures";

                    //                       return Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.center,
                    //                         children: [
                    //                           20.verticalSpace,
                    //                           Container(
                    //                             height: 5.h,
                    //                             width: 220.w,
                    //                             decoration: BoxDecoration(
                    //                               color: Colors.grey,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       360),
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           Padding(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 20.w),
                    //                             child: Row(
                    //                               children: [
                    //                                 SizedBox(
                    //                                   width: 45.w,
                    //                                   height: 45.w,
                    //                                   child: ClipRRect(
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(50.r),
                    //                                     child: Image.network(
                    //                                       documentSnapshot[
                    //                                               'user'][
                    //                                           'customer_picture'],
                    //                                       fit: BoxFit.fill,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 10.horizontalSpace,
                    //                                 Column(
                    //                                   crossAxisAlignment:
                    //                                       CrossAxisAlignment
                    //                                           .start,
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .spaceBetween,
                    //                                   children: [
                    //                                     Text(
                    //                                       documentSnapshot[
                    //                                               'user'][
                    //                                           'customer_full_name'],
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                     Text(
                    //                                       documentSnapshot[
                    //                                                       'order_type']
                    //                                                   .toString() !=
                    //                                               "0"
                    //                                           ? "Voyage"
                    //                                           : "Course",
                    //                                       style: bodyTextStyle,
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                                 const Spacer(),
                    //                                 Container(
                    //                                   height: 45.h,
                    //                                   width: 45.h,
                    //                                   margin: EdgeInsets.only(
                    //                                       left: 6.w),
                    //                                   decoration: BoxDecoration(
                    //                                     color: primary,
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(
                    //                                       50,
                    //                                     ),
                    //                                   ),
                    //                                   child: IconButton(
                    //                                     onPressed: () async {
                    //                                       String customerUid =
                    //                                           "";

                    //                                       var docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'orders')
                    //                                               .doc(controller
                    //                                                   .orderID)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         customerUid = data![
                    //                                             'customer_uid'];
                    //                                       }
                    //                                       String phoneNo = "";
                    //                                       docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'users')
                    //                                               .doc(
                    //                                                   customerUid)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         phoneNo = data![
                    //                                             'customer_phone_number'];
                    //                                       }

                    //                                       await FlutterPhoneDirectCaller
                    //                                           .callNumber(
                    //                                               phoneNo);
                    //                                     },
                    //                                     icon: const Icon(
                    //                                       Boxicons
                    //                                           .bx_phone_call,
                    //                                       color: Colors.white,
                    //                                     ),
                    //                                     color: primary,
                    //                                   ),
                    //                                 ),
                    //                                 Container(
                    //                                   height: 45.h,
                    //                                   width: 45.h,
                    //                                   margin: EdgeInsets.only(
                    //                                       left: 6.w),
                    //                                   decoration: BoxDecoration(
                    //                                     color: primary,
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(
                    //                                       50,
                    //                                     ),
                    //                                   ),
                    //                                   child: IconButton(
                    //                                     onPressed: () async {
                    //                                       String customerUid =
                    //                                           "";

                    //                                       var docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'orders')
                    //                                               .doc(controller
                    //                                                   .orderID)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         customerUid = data![
                    //                                             'customer_uid'];
                    //                                       }
                    //                                       String phoneNo = "";
                    //                                       docSnapshot =
                    //                                           await FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'users')
                    //                                               .doc(
                    //                                                   customerUid)
                    //                                               .get();
                    //                                       if (docSnapshot
                    //                                           .exists) {
                    //                                         Map<String,
                    //                                                 dynamic>?
                    //                                             data =
                    //                                             docSnapshot
                    //                                                 .data();
                    //                                         phoneNo = data![
                    //                                             'customer_phone_number'];
                    //                                       }

                    //                                       launch(
                    //                                           "https://wa.me/$phoneNo");
                    //                                     },
                    //                                     icon: const Icon(
                    //                                       Boxicons
                    //                                           .bx_message_rounded,
                    //                                       color: Colors.white,
                    //                                     ),
                    //                                     color: primary,
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           Padding(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 20.w),
                    //                             child: Row(
                    //                               children: [
                    //                                 Row(
                    //                                   children: [
                    //                                     const Icon(
                    //                                       Boxicons.bx_dollar,
                    //                                       color: primary,
                    //                                     ),
                    //                                     10.horizontalSpace,
                    //                                     Text(
                    //                                       '${documentSnapshot['order_purchase_amount']} MAD',
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                                 20.horizontalSpace,
                    //                                 Row(
                    //                                   children: [
                    //                                     const Icon(
                    //                                       Boxicons.bxs_map,
                    //                                       color: primary,
                    //                                     ),
                    //                                     10.horizontalSpace,
                    //                                     Text(
                    //                                       '${documentSnapshot['nbre_km_depart_destination']} Km   ($ttimeText)',
                    //                                       style: bodyTextStyle,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           20.verticalSpace,
                    //                           Padding(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 20.w),
                    //                             child: Row(
                    //                               children: [
                    //                                 InkWell(
                    //                                   onTap: () {
                    //                                     // Get.to(
                    //                                     //     () => HelpCenter(),
                    //                                     //     transition: Transition
                    //                                     //         .rightToLeft);
                    //                                   },
                    //                                   child: Container(
                    //                                     height: 55.h,
                    //                                     width: 55.h,
                    //                                     decoration:
                    //                                         BoxDecoration(
                    //                                       color: primary,
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                         360,
                    //                                       ),
                    //                                     ),
                    //                                     child: const Icon(
                    //                                       Boxicons
                    //                                           .bx_help_circle,
                    //                                       color: Colors.white,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 const Spacer(),
                    //                                 documentSnapshot[
                    //                                         'is_canceled_by_customer']
                    //                                     ? InkWell(
                    //                                         onTap: () async {
                    //                                           controller
                    //                                                   .startCourse =
                    //                                               false;
                    //                                           controller
                    //                                                   .isOnOrder =
                    //                                               false;
                    //                                           controller
                    //                                                   .isWithOrder =
                    //                                               false;
                    //                                           FirebaseFirestore
                    //                                               .instance
                    //                                               .collection(
                    //                                                   'drivers')
                    //                                               .doc(controller
                    //                                                   .userBase!
                    //                                                   .uid)
                    //                                               .update({
                    //                                             "is_on_order":
                    //                                                 false
                    //                                           });
                    //                                           controller.markers
                    //                                               .clear();
                    //                                           controller
                    //                                               .polylines
                    //                                               .clear();
                    //                                           controller
                    //                                               .update();
                    //                                           controller.markers
                    //                                               .clear();
                    //                                           controller
                    //                                               .polylines
                    //                                               .clear();
                    //                                           controller
                    //                                               .getUserLocation();
                    //                                           await controller
                    //                                               .getWithOrder();
                    //                                           controller
                    //                                               .update();
                    //                                         },
                    //                                         child: Container(
                    //                                           height: 55.h,
                    //                                           width: 260.w,
                    //                                           alignment:
                    //                                               Alignment
                    //                                                   .center,
                    //                                           decoration:
                    //                                               BoxDecoration(
                    //                                             color: documentSnapshot[
                    //                                                     'is_start']
                    //                                                 ? primary
                    //                                                 : Colors
                    //                                                     .red,
                    //                                             borderRadius:
                    //                                                 BorderRadius
                    //                                                     .circular(
                    //                                                         360),
                    //                                           ),
                    //                                           child: Text(
                    //                                             'Client a annulé la commande',
                    //                                             style:
                    //                                                 TextStyle(
                    //                                               fontSize:
                    //                                                   15.sp,
                    //                                               color: Colors
                    //                                                   .white,
                    //                                               fontFamily:
                    //                                                   "LatoSemiBold",
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       )
                    //                                     : InkWell(
                    //                                         onTap: () async {
                    //                                           String fcm =
                    //                                               documentSnapshot[
                    //                                                   "customer_fcm"];

                    //                                           newOne() async {
                    //                                             double
                    //                                                 distancee =
                    //                                                 double.parse(
                    //                                                         documentSnapshot['nbre_km_depart_destination']) /
                    //                                                     50;
                    //                                             print(ttime
                    //                                                 .toInt());
                    //                                             sendNotification(
                    //                                                 [fcm],
                    //                                                 "voyage a commencée",
                    //                                                 "votre chauffeur arrivera dans ${double.parse(documentSnapshot['nbre_km_depart_destination']) / 50 < 1 ? "${ttime.toStringAsFixed(1)} minutes" : "${ttime.toStringAsFixed(1)} heures"}  ");
                    //                                             plannedNotif(
                    //                                                 [
                    //                                                   fcm
                    //                                                 ],
                    //                                                 "Votre Motopickup vous attend.",
                    //                                                 "",
                    //                                                 DateTime.now().add(Duration(
                    //                                                     minutes:
                    //                                                         ttime.toInt())));
                    //                                             // double.parse(documentSnapshot['nbre_km_depart_destination']) /
                    //                                             //             50 <
                    //                                             //         1
                    //                                             // ? plannedNotif(
                    //                                             //     [
                    //                                             //         fcm
                    //                                             //       ],
                    //                                             //     "Votre Motopickup vous attend.",
                    //                                             //     " ",
                    //                                             //     DateTime.now().add(Duration(
                    //                                             //         minutes: ttime
                    //                                             //             .toInt())))
                    //                                             // : plannedNotif(
                    //                                             //     [
                    //                                             //         fcm
                    //                                             //       ],
                    //                                             //     "Votre Motopickup vous attend.",
                    //                                             //     " ",
                    //                                             //     DateTime.now().add(Duration(
                    //                                             //         hours:
                    //                                             //             ttime.toInt())));
                    //                                             // await updateStatusOrder(
                    //                                             //     controller
                    //                                             //         .orderID);
                    //                                             controller.updateMyLocation(
                    //                                                 documentSnapshot[
                    //                                                     "order_id"]);
                    //                                             controller
                    //                                                 .update();
                    //                                           }

                    //                                           documentSnapshot[
                    //                                                       'is_start'] ==
                    //                                                   false
                    //                                               ? newOne()
                    //                                               : paiment(
                    //                                                   context,
                    //                                                   () async {
                    //                                                   // sendNotification(
                    //                                                   //     [fcm],
                    //                                                   //     "voyage est finis",
                    //                                                   //     "au revoir");
                    //                                                   // updateSuccedOrder(
                    //                                                   //     controller
                    //                                                   //         .orderID);
                    //                                                   controller
                    //                                                           .startCourse =
                    //                                                       false;
                    //                                                   controller
                    //                                                           .isOnOrder =
                    //                                                       false;
                    //                                                   controller
                    //                                                           .isWithOrder =
                    //                                                       false;
                    //                                                   FirebaseFirestore
                    //                                                       .instance
                    //                                                       .collection(
                    //                                                           'drivers')
                    //                                                       .doc(controller
                    //                                                           .userBase!
                    //                                                           .uid)
                    //                                                       .update({
                    //                                                     "is_on_order":
                    //                                                         false
                    //                                                   });
                    //                                                   await controller
                    //                                                       .getWithOrder();
                    //                                                   controller
                    //                                                       .markers
                    //                                                       .clear();
                    //                                                   controller
                    //                                                       .polylines
                    //                                                       .clear();
                    //                                                   await SessionManager().set(
                    //                                                       "order_id",
                    //                                                       controller
                    //                                                           .orderID);
                    //                                                   await SessionManager().set(
                    //                                                       "distance",
                    //                                                       Geolocator.distanceBetween(
                    //                                                           documentSnapshot["order_pickup_location"]['latitude'],
                    //                                                           documentSnapshot["order_pickup_location"]['longitude'],
                    //                                                           controller.latitude!,
                    //                                                           controller.longtitude!));
                    //                                                   controller
                    //                                                       .stopTimer();
                    //                                                   // Get.delete<HomePageController>();
                    //                                                   // Get.offAll(
                    //                                                   //     () =>
                    //                                                   //         RateClient());
                    //                                                 });
                    //                                           controller
                    //                                               .update();
                    //                                         },
                    //                                         child: Container(
                    //                                           height: 55.h,
                    //                                           width: 260.w,
                    //                                           alignment:
                    //                                               Alignment
                    //                                                   .center,
                    //                                           decoration:
                    //                                               BoxDecoration(
                    //                                             color: documentSnapshot[
                    //                                                         'is_start'] ==
                    //                                                     false
                    //                                                 ? primary
                    //                                                 : Colors
                    //                                                     .red,
                    //                                             borderRadius:
                    //                                                 BorderRadius
                    //                                                     .circular(
                    //                                                         360),
                    //                                           ),
                    //                                           child: Text(
                    //                                             documentSnapshot[
                    //                                                         'is_start'] ==
                    //                                                     false
                    //                                                 ? documentSnapshot['order_type'] !=
                    //                                                         0
                    //                                                     ? 'Commencez le voyage'
                    //                                                     : 'Commencer la course'
                    //                                                 : documentSnapshot['order_type'] !=
                    //                                                         0
                    //                                                     ? 'Finir le voyage'
                    //                                                     : 'Finir la course',
                    //                                             style:
                    //                                                 TextStyle(
                    //                                               fontSize:
                    //                                                   15.sp,
                    //                                               color: Colors
                    //                                                   .white,
                    //                                               fontFamily:
                    //                                                   "LatoSemiBold",
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 20.h,
                    //                           ),
                    //                         ],
                    //                       );
                    //                     }
                    //                   },
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //     ],
                    //   )

                    //===================================================== Map =====================================================

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
