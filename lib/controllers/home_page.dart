// ignore_for_file: file_names, unused_element

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/models/user.dart';

class HomePageController extends GetxController {
  MpUser? userBase;
  RxBool isTrue = false.obs;
  String address = 'Nous ne pouvons pas obtenir votre position actuelle';
  bool isPlanned = false;
  List? cities;
  bool isAvailable = false;

  GetStorage box = GetStorage();

  bool status = false;

  var kGooglePlex;

  var polylines;

  var markers;

  // GoogleMapController mapController = GoogleMapController();

  bool isOnOrder = false;

  var city;

  var latitude;

  var longtitude;

  var isWithOrder;

  var stars;

  var orderID;

  bool startCourse = false;

  double ttime = 0.0;

  getOrdersPlanned() async {
    if (userBase!.plannedDelivery != 0 ||
        userBase!.plannedTrip != 0) {
      isPlanned = true;
    } else {
      isPlanned = false;
    }
  }

  Future<void> _getUserLocation() async {
    try {
      // if (userBase!.customer_city == '') {
      //   Position position = await Geolocator.getCurrentPosition(
      //       desiredAccuracy: LocationAccuracy.high);
      //   List<Placemark> placemarks = await placemarkFromCoordinates(
      //       position.latitude, position.longitude,
      //       localeIdentifier: "fr_FR");
      //   address = '${placemarks.first.locality}, ${placemarks.first.country}';
      //   isAvailable = cities!.contains(placemarks.first.locality);
      //   print(
      //       ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      // } else {
      //   String add = '';
      //   List<Location> locations = await locationFromAddress(
      //       userBase!.customer_city,
      //       localeIdentifier: "fr_FR");
      //   List<Placemark>? placemarks;
      //   if (userBase!.customer_latitude != 0 &&
      //       userBase!.customer_longitude != 0) {
      //     placemarks = await placemarkFromCoordinates(
      //         userBase!.customer_latitude, userBase!.customer_longitude);

      //     add = '${placemarks.first.locality}, ${placemarks.first.country}';
      //     isAvailable = cities!.contains(placemarks.first.locality);
      //     print(
      //         ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      //   } else {
      //     placemarks = await placemarkFromCoordinates(
      //         locations.first.latitude, locations.first.longitude,
      //         localeIdentifier: "fr_FR");
      //     add = '${placemarks.first.locality}';

      //     isAvailable = cities!.contains(placemarks.first.locality);

      //     print(
      //         ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      //   }
      //   print(cities);
      //   address = add;
      //   print(
      //       ' $isAvailable  ${placemarks.first.locality}, ${placemarks.first.country}');
      // }
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

  @override
  void onInit() async {
    // super.onInit();
    // await getCurrentUser().then((value) async {
    //  await  initOneSignal();
    //   userBase = value;
    //   print(userBase);
    //   updateFcm(userBase!);
    //   saveCurrentUser(value!);
    //   await getConfigParams().then((value) => cities = value);
    //   await getOrdersPlanned();
    //   await _getUserLocation();
    //   isTrue.toggle();
    //   update();
    // });
  }

  void goOnline() {}

  void setRoad(documentSnapshot, documentSnapshot2, documentSnapshot3, documentSnapshot4) {}

  void stopTimer() {}

  void getUserLocation() {}

  getWithOrder() {}

  void updateMyLocation(documentSnapshot) {}
}
