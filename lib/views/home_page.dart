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
import 'package:motopickupdriver/utils/models/order.dart' as order_class;
import 'package:motopickupdriver/views/order_informations.dart';

import '../utils/services.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
                        // disabled: controller.userBase!.currentOrderCustomer !=
                        //       null ? true : false,
                        onToggle: (val) async {
                          await getCurrentUser().then((userFromDB) {
                            controller.userBase = userFromDB;
                          
                            if (controller.userBase!.currentOrderCustomer !=
                                null) {
                              showAlertDialogOneButton(
                                  context,
                                  "Erreur",
                                  "Vous devez terminer votre commande en tant que client.",
                                  "ok");
                              controller.status = false;
                              controller.update();
                            } else {
                              controller.status = !controller.status;
                              controller.goOnline();
                              controller.update();
                            }
                          });
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
                    ? Stack(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('mp_orders')
                                // .where("is_canceled_by_customer", isEqualTo: false)
                                .where('drivers_concerned',
                                    arrayContains: controller.userBase!.uid)
                                .where('driver', isNull: true)
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
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
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
                                              .contains(
                                                  controller.userBase!.uid) &&
                                          !documentSnapshot['drivers_accepted']
                                              .contains(
                                                  (controller.userBase!.uid))) {
                                        double distance = Geolocator.distanceBetween(
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
                                        //  if ((distance / 1000) >
                                        //         documentSnapshot['km_radius'] &&
                                        //     controller.isWithOrder == false) {
                                        controller.stars = documentSnapshot[
                                                            'customer']
                                                        ['customer_note'] /
                                                    documentSnapshot['customer']
                                                        [
                                                        'customer_total_orders'] ==
                                                0
                                            ? 1
                                            : documentSnapshot['customer']
                                                ['customer_total_orders'];
                                        // controller.showCard=true;
                                        // controller.update();
                                        controller.isPlanned =
                                            documentSnapshot['is_planned'];
                                       
                                        return OrdersCard(
                                          isPlanned: controller.isPlanned,
                                          status: 1,
                                          photo: documentSnapshot["customer"]
                                              ["profile_picture"],
                                          username: documentSnapshot["customer"]
                                              ["full_name"],
                                          orderType:
                                              documentSnapshot["order_type"]
                                                  .toString(),
                                          from:
                                              documentSnapshot["address_from"],
                                          to: documentSnapshot["address_to"],
                                          idOrder: documentSnapshot["order_id"],
                                          drive: controller.userBase!,
                                          distance: (distance / 1000)
                                              .toStringAsFixed(2),
                                          stars: controller.stars.toDouble(),
                                          accepte: () async {
                                            await FirebaseFirestore.instance
                                                .collection('mp_users')
                                                .doc(controller.userBase!.uid)
                                                .update({
                                              "current_order_driver":
                                                  documentSnapshot["order_id"]
                                            }).then((value) async {
                                              await FirebaseFirestore.instance
                                                  .collection("mp_orders")
                                                  .doc(documentSnapshot[
                                                      "order_id"])
                                                  .update({
                                                "drivers_accepted":
                                                    FieldValue.arrayUnion([
                                                  controller.userBase!.toJson(),
                                                  // controller.userBase!.uid,
                                                ]),
                                                'drivers_concerned':
                                                    FieldValue.arrayRemove([
                                                  controller.userBase!.uid
                                                ]),
                                                "status": "driver_accepted"
                                              }).then((value) {
                                                controller.order =
                                                    order_class.Order.fromJson(
                                                        documentSnapshot.data()
                                                            as Map<String,
                                                                dynamic>);
                                              
                                                controller.isOnOrder = true;
                                                controller.isWithOrder = true;
                                                Get.offAll(
                                                    () => OrderInformations(),
                                                    transition:
                                                        Transition.leftToRight);
                                                controller.update();
                                              });
                                            });
                                          },
                                        );
                                      } else {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                      }
                                    },
                                  );
                                }
                              }
                            },
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
                            function: () async {
                              // controller.status = true;
                              // controller.goOnline();
                              // controller.update();

                              await getCurrentUser().then((userFromDB) {
                                controller.userBase = userFromDB;
                           
                                if (controller.userBase!.currentOrderCustomer !=
                                    null) {
                                  showAlertDialogOneButton(
                                      context,
                                      "Erreur",
                                      "Vous devez terminer votre commande en tant que client.",
                                      "ok");
                                  controller.status = false;
                                  controller.update();
                                } else {
                                  controller.status = !controller.status;
                                  controller.goOnline();
                                  controller.update();
                                }
                              });
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
