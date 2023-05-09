// ignore_for_file: file_names, unused_element

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
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/services.dart';

import '../utils/models/user.dart';

class HomePageController extends GetxController {
  GeoFlutterFire? geo = GeoFlutterFire();
  Stream<List<DocumentSnapshot>>? stream;
  GeoFirePoint? center;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MpUser? userBase;

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

  double? latitude, longtitude;

  var stars;

  var orderID;

  bool isOnOrder = false, startCourse = false, isWithOrder = false;

  double ttime = 0.0;

  bool isActiveOne = false;

  getOrdersPlanned() async {
    if (userBase!.plannedDelivery != 0 || userBase!.plannedTrip != 0) {
      isPlanned = true;
    } else {
      isPlanned = false;
    }
  }

  Future<void> _getUserLocation() async {
    try {
      if (userBase!.currentCity == '') {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude,
            localeIdentifier: "fr_FR");
        address = '${placemarks.first.locality}, ${placemarks.first.country}';
        isAvailable = cities!.contains(placemarks.first.locality);
        print(
            ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      } else {
        String add = '';
        List<Location> locations = await locationFromAddress(
            userBase!.currentCity!,
            localeIdentifier: "fr_FR");
        List<Placemark>? placemarks;
        if (userBase!.latitude != 0 && userBase!.longitude != 0) {
          placemarks = await placemarkFromCoordinates(
              userBase!.latitude!, userBase!.longitude!);

          add = '${placemarks.first.locality}, ${placemarks.first.country}';
          isAvailable = cities!.contains(placemarks.first.locality);
          print(
              ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
        } else {
          placemarks = await placemarkFromCoordinates(
              locations.first.latitude, locations.first.longitude,
              localeIdentifier: "fr_FR");
          add = '${placemarks.first.locality}';

          isAvailable = cities!.contains(placemarks.first.locality);

          print(
              ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
        }
        print(cities);
        address = add;
        print(
            ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: "fr_FR");
      address = '${placemarks.first.locality}, ${placemarks.first.country}';
      isAvailable = cities!.contains(placemarks.first.locality);
      print(
          ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
    } catch (e) {
      address = 'Nous ne pouvons pas obtenir votre position actuelle';
    }
    update();
  }

  void goOnline() {
    userBase!.isOnline = status;
    FirebaseFirestore.instance
        .collection('mp_users')
        .doc(userBase!.uid)
        .update(userBase!.toJson());
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
      target: LatLng(latitude!, longtitude!),
      zoom: 18,
    );
    Polyline polylineDriver = await PolylineService().drawPolyline(
      LatLng(
        latitude!,
        longtitude!,
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

  void stopTimer() {}

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
    longtitude = position.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "fr_FR");
    city = placemarks.first.locality;
    city = removeDiacritics(city ?? "");
    userBase!.latitude = latitude!;
    userBase!.longitude = longtitude!;
    kGooglePlex = CameraPosition(
      target: LatLng(latitude!, longtitude!),
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

  void updateMyLocation(documentSnapshot) {}

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      await initOneSignal();
      userBase = value;
      status = userBase!.isOnline ?? false;
      await getUserLocation();
      userBase!.totalOrders = 0;

      print("hhhhh: ${userBase!.latitude} ${userBase!.longitude}");
      center = GeoFlutterFire().point(
          latitude: userBase!.latitude!, longitude: userBase!.longitude!);
      // stream = geo!
      //     .collection(
      //         collectionRef: FirebaseFirestore.instance.collection("mp_orders"))
      //     .within(
      //         center: center!,
      //         radius: 15,
      //         field: 'order_pickup_location',
      //         strictMode: true) as Stream<QuerySnapshot<Object?>>?;

      print(userBase);
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
