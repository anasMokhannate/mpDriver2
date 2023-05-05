// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motopickupdriver/utils/models/ListItems.dart';
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/views/welcome_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'models/user.dart';

handlerPermission() async {
  var permission = await Permission.sensors.status;
  if (permission.isDenied) {
    await Permission.phone.request();
    await Permission.location.request();
  }
  if (permission.isRestricted) {
    await Permission.phone.request();
    await Permission.location.request();
  }
  if (permission.isPermanentlyDenied) {
    await Permission.phone.request();
    await Permission.location.request();
  }
  if (permission.isLimited) {
    await Permission.phone.request();
    await Permission.location.request();
  }
}

List<DropdownMenuItem<ListItem>>? buildDropDownMenuItems(List listItems) {
  List<DropdownMenuItem<ListItem>>? items = [];
  for (ListItem listItem in listItems) {
    items.add(
      DropdownMenuItem(
        value: listItem,
        child: Text(listItem.name),
      ),
    );
  }
  return items;
}

Future<MpUser?> getUserFromMemory() async {
  MpUser? user;
  await SessionManager().get("currentUser").then((value) {
    user = MpUser.fromJson(value);
  });
  return user;
}

Future<MpUser?> getCurrentUser() async {
  MpUser? currentUser;
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  await getUser(firebaseUser.uid).then((value) async {
    currentUser = value;
  });
  return currentUser;
}

Future<bool> saveCurrentUser(MpUser userBase) async {
  bool done = false;
  await SessionManager()
      .set('currentUser', userBase)
      .then((value) => done = true);
  return done;
}

const mapKey = "AIzaSyBqSKcIDvITQ3xiwX71pCKV8XonGuHeIgM";
const facebookKey = "614082983354009";

class PolylineService {
  Future<Polyline> drawPolyline(LatLng from, LatLng to, Color color) async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude));

    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
    return Polyline(
        polylineId: PolylineId("polyline_id ${result.points.length}"),
        color: color,
        points: polylineCoordinates,
        width: 3,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap);
  }
}

Future<void> initOneSignal() async {
  await OneSignal.shared.setAppId('ab81ccaf-372d-46ad-a8ff-8cee94790e75');
  String osUserID = 'userID';
  OneSignal.shared.setSubscriptionObserver((changes) async {
    osUserID = changes.to.userId ?? '';
    String playerid = osUserID;
    await SessionManager().set('user_fcm', playerid);
  });
  await OneSignal.shared.promptUserForPushNotificationPermission(
    fallbackToSettings: true,
  );

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});
  await OneSignal.shared.getDeviceState();
}

updateFcm(MpUser user) async {
  List fcmList = [];
  await SessionManager().get('user_fcm').then((value) {
    fcmList.add(value);
    FirebaseFirestore.instance
      .collection('mp_users')
      .doc(user.uid)
      .update({"fcmList": fcmList});
  });
  // user.fcmList!.add(fcm);
  await saveCurrentUser(user);
}

sendNotification(fcm, heading, content) async {
  await OneSignal.shared.postNotification(OSCreateNotification(
    playerIds: fcm,
    content: content,
    heading: heading,
  ));
}

checkIsFirstTime() async {
  final isFirstTime = await SessionManager().get('isFirstTime');
  if (isFirstTime == null) {
    await SessionManager().set("isFirstTime", false);
    await SessionManager().set("isActiveNotificationDriver", true);
  }
}

sendPlanifiedNotification(fcm, heading, content, whenDate) async {
  DateTime dateTime = DateTime.now();
  await OneSignal.shared.postNotification(OSCreateNotification(
    playerIds: fcm,
    content: content,
    heading: heading,
    sendAfter: DateTime(
            whenDate.year,
            whenDate.month,
            whenDate.day,
            whenDate.hour - int.parse(dateTime.timeZoneName),
            whenDate.minute,
            0)
        .subtract(const Duration(minutes: 30)),
  ));
}

plannedNotif(fcm, heading, content, whenDate) async {
  DateTime dateTime = DateTime.now();
  await OneSignal.shared.postNotification(OSCreateNotification(
    playerIds: fcm,
    content: content,
    heading: heading,
    sendAfter: DateTime(whenDate.year, whenDate.month, whenDate.day,
        whenDate.hour - int.parse(dateTime.timeZoneName), whenDate.minute, 0),
  ));
}


signOut() async {
  await FirebaseAuth.instance.signOut().then((value) async {
    await GoogleSignIn().signOut().then((value) {
      SessionManager().remove("currentUser");
      
      Get.offAll(() => WelcomeScreen());
    });
  });
}