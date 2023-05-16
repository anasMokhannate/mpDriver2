// ignore_for_file: file_names, unused_element

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/services.dart';

import '../utils/models/user.dart';

class OrderInformationsController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;
  double ttime = 0;
  bool isOnline = false;
  String? orderStatus;
  Timer? timer;
  String? city;
  double? latitude, longitude;
  CameraPosition? kGooglePlex;

  double? distance, startlatitude, startlongitude, endlatitude, endlongitude;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  BitmapDescriptor? startIcon, endIcon, motoIcon;
  GoogleMapController? mapController;
  bool isOnOrder = false, startCourse = false;
  bool isWithOrder = false;
  double stars = 0;
  List trajet = [];
  String? driverId;
// bool showCard=false;
  String? orderID;

  getWithOrder() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('mp_users')
        .doc(userBase!.uid)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      isWithOrder = data!['is_on_order'];
      update();
    }
  }

  getOrderStatus() async {
    print("zzz currentOrderId ${userBase!.currentOrderId}");
    var docSnapshot = await FirebaseFirestore.instance
        .collection('mp_orders')
        .doc(userBase!.currentOrderId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      orderStatus = data!['status'];
      // update();
    }
  }

  goOnline() async {
    userBase!.isOnline = isOnline;
    FirebaseFirestore.instance
        .collection('mp_users')
        .doc(userBase!.uid)
        .update(userBase!.toJson());
  }

  getUserLocation() async {
    motoIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        'assets/images/marker_moto.png');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    kGooglePlex = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 12,
    );
    latitude = position.latitude;
    longitude = position.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "fr_FR");
    city = placemarks.first.locality;
    city = removeDiacritics(city ?? "");
    userBase!.location?["geopoint"].latitude = latitude!;
    userBase!.location?["geopoint"].longitude = longitude!;
    kGooglePlex = CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 16,
    );
    // markers.add(
    //   Marker(
    //     markerId: const MarkerId('id-1'),
    //     icon: motoIcon!,
    //     position: LatLng(
    //       latitude!,
    //       longitude!,
    //     ),
    //   ),
    // );
    update();
  }

  // updateMyLocation(orderId) {
  //   timer = Timer.periodic(const Duration(minutes: 1), (val) async {
  //     getUserLocation();
  //     trajet.add({
  //       "latitude": latitude,
  //       "longitude": longitude,
  //     });
  //     userBase!.location!["geopoint"].longitude = longitude!;
  //     userBase!.location!["geopoint"].latitude = latitude!;
  //     await FirebaseFirestore.instance
  //         .collection('orders')
  //         .doc(orderId)
  //         .update({
  //       'driver': userBase!.toJson(),
  //       'trajet': FieldValue.arrayUnion(trajet)
  //     });
  //   });
  // }

  // myLocationUpdateNotif() {
  //   Timer? timer3;
  //   timer3 = Timer.periodic(const Duration(minutes: 1), (val) async {
  //     getUserLocation();
  //     if (userBase!.isOnline!) {
  //       await FirebaseFirestore.instance
  //           .collection('mp_users')
  //           .doc(userBase!.uid)
  //           .update({
  //         'driver_longitude': longitude,
  //         'driver_latitude': latitude,
  //       });
  //     }
  //   });
  // }

  // stopTimer() {
  //   timer!.cancel();
  // }

  setRoad(startLatitude, startLongitude, endlatitude, endlongitude) async {
    startIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        'assets/images/marker_start.png');
    endIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        'assets/images/marker_end.png');
    markers.addAll([
      Marker(
        markerId: const MarkerId('id-2'),
        icon: startIcon!,
        position: LatLng(
          startLatitude,
          startLongitude,
        ),
      ),
      Marker(
        markerId: const MarkerId('id-3'),
        icon: endIcon!,
        position: LatLng(
          endlatitude,
          endlongitude,
        ),
      ),
    ]);
    Polyline polyline = await PolylineService().drawPolyline(
      LatLng(
        startLatitude,
        startLongitude,
      ),
      LatLng(
        endlatitude,
        endlongitude,
      ),
      primary,
    );
    kGooglePlex = CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 18,
    );
    Polyline polylineDriver = await PolylineService().drawPolyline(
      LatLng(
        latitude!,
        longitude!,
      ),
      LatLng(
        startLatitude,
        startLongitude,
      ),
      Colors.red,
    );
    polylines.clear();
    polylines.addAll([polyline, polylineDriver]);
    // update();
  }

  Future<void> drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to, primary);
    polylines.clear();
    polylines.add(polyline);
    PolylineService().distanceBetween(from, to).then((value) async {
      distance = value;
    });
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    print("driver id $driverId");
    await getCurrentUser().then((value) async {
      userBase = value;
      isOnline = userBase!.isOnline ?? false;
      await saveCurrentUser(userBase!);
      await getUserLocation();
    });

    orderID = Get.arguments;
    print("ssss $orderID");
    await getWithOrder();
    await getOrderStatus();
    startIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        'assets/images/marker_start.png');
    endIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        'assets/images/marker_end.png');
    isTrue.toggle();
    // await myLocationUpdateNotif();
    // await updateMyLocation();

    update();
  }
}
