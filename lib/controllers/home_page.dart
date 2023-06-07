// ignore_for_file: file_names, unused_element

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/models/order.dart' as Orderr;
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:location/location.dart' as loc;

import '../utils/models/user.dart';

class HomePageController extends GetxController {
  GeoFlutterFire? geo = GeoFlutterFire();
  Stream<List<DocumentSnapshot>>? stream;
  GeoFirePoint? center;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MpUser? userBase;
  StreamSubscription<Position>? positionStream;

  RxBool isTrue = false.obs;
  String address = 'Nous ne pouvons pas obtenir votre position actuelle';
  bool isPlanned = false;
  List? cities;
  bool isAvailable = false;
  BitmapDescriptor? startIcon, endIcon, motoIcon;

  GetStorage box = GetStorage();

  bool status = false;

  CameraPosition? kGooglePlex;

  final Set<Polyline> polylines = {};

  final Set<Marker> markers = {};

  // GoogleMapController mapController = GoogleMapController();

  String? city;

  double? latitude, longitude;

  var stars;

  bool isOnOrder = false, startCourse = false, isWithOrder = false;

  double ttime = 0.0;

  bool isActiveOne = false;
  Orderr.Order order = Orderr.Order();

  getOrdersPlanned() async {
    if (userBase!.plannedDelivery != 0 || userBase!.plannedTrip != 0) {
      isPlanned = true;
    } else {
      isPlanned = false;
    }
  }

  void startLocationUpdates() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen((Position position) {
      // Update the location in Firestore
      if (userBase!.isOnline ?? false) {
        updateLocationInFirestore(position.latitude, position.longitude);
      }
    });
  }

  updateLocationInFirestore(latitude, longitude) async {
    userBase!.location =
        GeoFlutterFire().point(latitude: latitude!, longitude: longitude!).data;

    // await completeUser(userBase!);
    await FirebaseFirestore.instance
        .collection("mp_users")
        .doc(userBase!.uid)
        .update({
      'location': userBase!.location,
      // 'driver_latitude': latitude,
    }).then((value) {});
  }

// Stop listening for location updates
  void stopLocationUpdates() {
    positionStream?.cancel();
  }

  void goOnline() {
    userBase!.isOnline = status;
    FirebaseFirestore.instance
        .collection('mp_users')
        .doc(userBase!.uid)
        .update({'is_online': status});
    update();
  }

  Future<void> setRoad(
      startLatitude, startLongtitude, endlatitude, endlongtitude) async {
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
          startLongtitude,
        ),
      ),
      Marker(
        markerId: const MarkerId('id-3'),
        icon: endIcon!,
        position: LatLng(
          endlatitude,
          endlongtitude,
        ),
      ),
    ]);
    Polyline polyline = await PolylineService().drawPolyline(
      LatLng(
        startLatitude,
        startLongtitude,
      ),
      LatLng(
        endlatitude,
        endlongtitude,
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
        startLongtitude,
      ),
      Colors.red,
    );
    polylines.clear();
    polylines.addAll([polyline, polylineDriver]);
    update();
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
    userBase!.location =
        GeoFlutterFire().point(latitude: latitude!, longitude: longitude!).data;
    await completeUser(userBase!);
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
    //       longtitude!,
    //     ),
    //   ),
    // );
    update();
  }

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

  // void callbackDispatcher() {
  //   Workmanager().executeTask((taskName, inputData) async {
  //
  //     return Future.value(true);
  //   });
  // }

  @override
  void onInit() async {
    super.onInit();

    await getCurrentUser().then((value) async {
      await initOneSignal();
      loc.Location location = loc.Location();

      userBase = value;
      status = userBase!.isOnline ?? false;
      //userBase!.driverTotalOrders = 0;
      userBase!.isActivatedAccount = true;
      await getUserLocation();
      center = GeoFirePoint(latitude!, longitude!);
      bool bgModeEnabled = await location.isBackgroundModeEnabled();
      if (!bgModeEnabled) {
        location.enableBackgroundMode(enable: true);
      }

      startLocationUpdates();

      // stream = geo!
      //     .collection(
      //         collectionRef: FirebaseFirestore.instance.collection("mp_orders"))
      //     .within(
      //         center: center!,
      //         radius: 15,
      //         field: 'order_pickup_location',
      //         strictMode: true) as Stream<QuerySnapshot<Object?>>?;

      updateFcm(userBase!);
      saveCurrentUser(value!);
      await getConfigParams().then((value) => cities = value);
      await getOrdersPlanned();
      // await _getUserLocation();
      isTrue.toggle();
      update();
    });
  }
}
