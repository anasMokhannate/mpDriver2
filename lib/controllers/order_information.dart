// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/services.dart';

import 'home_page.dart';

class OrderInformationController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;
  String? orderId;
  String clientNumber = "";
  double startsmean = 0;

  HomePageController contrr = Get.put(HomePageController());

  bool isActiveOne = false, isActiveTwo = true;
  String time = "";

  getTime() async {
    String finallong = "-5.571775585412979";
    String finallat = "33.85889792239378";
    String oringinlong = "-6.571775585412979";
    String oringinlat = "23.85889792239378";
    Dio dio = Dio();
    var response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C,-73.9976592&key=$mapKey");

    update();
  }

  getClientData() async {
    String id = "";
    var docSnapshot = await FirebaseFirestore.instance
        .collection('mp_orders')
        .doc(orderId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      id = data!["customer"]['uid'];
      update();
      docSnapshot =
          await FirebaseFirestore.instance.collection('mp_users').doc(id).get();
    }
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      clientNumber = data!['phone_number'];
      startsmean = data['note'] / data['total_orders'];
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getTime();
    await getUserFromMemory().then((value) async {
      userBase = value;
      // orderId = Get.arguments[0];
      await getClientData();
      isTrue = true.obs;
      update();
    });
  }
}
