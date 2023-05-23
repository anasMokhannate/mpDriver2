import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motopickupdriver/utils/models/emergency.dart';
import 'package:motopickupdriver/utils/services.dart';

import 'models/user.dart';
import 'models/order.dart' as orderModel;

Future<String> checkPhoneNumber(phoneNo) async {
  String message = "not-found";

  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      // .where('auth_type', whereIn: ["Phone", "Facebook", "Google"])
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) message = "found-in-users";
  });
  return message;
}

Future getConfigParams() async {
  List cities = [];
  await FirebaseFirestore.instance
      .collection('config')
      .doc('config-params')
      .snapshots()
      .first
      .then((value) {
    cities = value.get('available_cities');
  });

  return cities;
}

Future<bool> checkEmail(email) async {
  bool message = false;
  //String message = "not-found";
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('email', isEqualTo: email)
      //.where('auth_type', whereIn: ["Phone", "Facebook", "Google"])
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) {
      message = true;
    } else {
      message = false;
    }
  });
  return message;
}

//get user from firebase
Future<MpUser> getUser(uid) async {
  MpUser user;
  var docSnapshot =
      await FirebaseFirestore.instance.collection('mp_users').doc(uid).get();

  Map<String, dynamic>? data = docSnapshot.data();
  user = MpUser.fromJson(data ?? {});
  return user;
}

Future createUser(MpUser user) async {
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);
  await docUser.set(user.toJson());
}

Future deleteUser(MpUser user, reason) async {
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);

  await docUser.update({
    'is_deleted_account': true,
    'reason_for_delete': reason ?? '-',
    'is_activated_account': false,
    'is_verified_account': false
  });
}

Future<String?> getProvider(String email) async {
  print('email: $email');
  String provider = "";
  await FirebaseFirestore.instance
      .collection("mp_users")
      .where("email", isEqualTo: email)
      .where("is_deleted_account", isEqualTo: false)
      //  .where("is_driver", isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) {
      provider = value.docs.first.get("auth_type");
    }
  });
  print('provider: $provider');
  return provider;
}

Future<String?> loginWithPhone(phone) async {
  String? email;
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phone)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) {
      email = value.docs.first.get('email');
    }
  });

  return email;
}

// Future<MpUser?> getUserByPhone(phone) async {
//   MpUser? email;
//   email = await FirebaseFirestore.instance
//       .collection('mp_users')
//       .where('phone_number', isEqualTo: phone)
//       .where('is_deleted_account', isEqualTo: false)
//       .where('auth_type', isEqualTo: 'Phone')
//       .get();

//   return email;
// }

Future completeUser(MpUser user) async {
  await FirebaseFirestore.instance
      .collection('mp_users')
      .doc(user.uid)
      .update(user.toJson());
}

//===================================== Google Facebook Auth===============================================
Future<bool> isUserExist(uid) async {
  bool exist = true;
  MpUser? user;
  var docSnapshot = await FirebaseFirestore.instance
      .collection('mp_users')
      .doc(uid)
      .get()
      .then((value) {
    if (value.exists) {
      exist = true;
    } else {
      exist = false;
    }
  });
  // await FirebaseFirestore.instance
  //     .collection('mp_users')
  //     .where('uid', isEqualTo: uid)
  //     .where('isDeleted', isEqualTo: false)
  //     .snapshots()
  //     .first
  //     .then((value) async {});
  return exist;
}
//===================================== Google Facebook Auth===============================================

Future createEmergency(Emergency emergency) async {
  final docUser =
      FirebaseFirestore.instance.collection('emergency').doc(emergency.user);

  await docUser.set(emergency.toJson());
}

// Future updateStatusOrder(orderId) async {
//   FirebaseFirestore.instance
//       .collection('mp_orders')
//       .doc(orderId)
//       .update({"is_start": true});
// }

// Future updateSuccedOrder(orderId) async {
//   FirebaseFirestore.instance
//       .collection('mp_orders')
//       .doc(orderId)
//       .update({"is_succeded": true, 'status': 1});
// }

clearCurrentOrders(String customerId) async {
  await getUserFromMemory().then((value) async {
    await FirebaseFirestore.instance
        .collection('mp_users')
        .doc(value!.uid)
        .update({
      "current_order_driver": null,
    });

    await FirebaseFirestore.instance
        .collection('mp_users')
        .doc(customerId)
        .update({
      "current_order_customer": null,
    });
  });
}

getOrderStatus(String orderId) async {
  var docSnapshot = await FirebaseFirestore.instance
      .collection('mp_orders')
      .doc(orderId)
      .get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    //orderStatus = data!['status'];
    return data!['status'];
    // update();
  }
}

Future annulerOrder(MpUser driver, orderModel.Order order) async {
  print("fdfasf ${order.driversAccepted} ");
  print("kjh  ${driver.uid}");
  print(order.customer!['uid']);

  if (order.status == 'customer_accepted') {
    await FirebaseFirestore.instance
        .collection('mp_orders')
        .doc(order.orderId)
        .update(({
          'is_canceled_by_driver': true,
          'status': 'order_canceled',
          'is_finished': true,
          'drivers_declined': FieldValue.arrayUnion([driver.uid]),
          // 'drivers_accepted': FieldValue.arrayRemove([0]),
          'drivers_concerned': FieldValue.arrayRemove([driver.uid])
        }));
  } else if (order.status == 'driver_accepted') {
    await FirebaseFirestore.instance
        .collection('mp_orders')
        .doc(order.orderId)
        .update(({
          // 'status': 'canceled_by_driver',
          'drivers_declined': FieldValue.arrayUnion([driver.uid]),
          // 'drivers_accepted': FieldValue.arrayRemove([0]),
          'drivers_concerned': FieldValue.arrayRemove([driver.uid])
        }));
  }

  await clearCurrentOrders(order.customer!['uid']);

  String type = "";
  var docSnapshot2 = await FirebaseFirestore.instance
      .collection('mp_orders')
      .doc(order.orderId)
      .get();
  if (docSnapshot2.exists) {
    Map<String, dynamic>? data = docSnapshot2.data();
    type = data!['order_type'].toString();
    type != '0'
        ? FirebaseFirestore.instance
            .collection('mp_users')
            .doc(driver.uid)
            .update({
            // "current_order_driver": null,
            "driver_cancelled_trip": FieldValue.increment(1),
          })
        : FirebaseFirestore.instance
            .collection('mp_users')
            .doc(driver.uid)
            .update({
            // "current_order_driver": null,
            "driver_cancelled_delivery": FieldValue.increment(1),
          });
  }
}

Future refuserOrder(MpUser driver, orderId) async {
  FirebaseFirestore.instance.collection('mp_orders').doc(orderId).update(({
        // 'is_canceled_by_driver': true,
        // 'status': 'canceled_by_driver',
        'drivers_declined': FieldValue.arrayUnion([driver.uid]),
        'drivers_concerned': FieldValue.arrayRemove([driver.uid])
      }));
  String type = "";
  var docSnapshot2 = await FirebaseFirestore.instance
      .collection('mp_orders')
      .doc(orderId)
      .get();
  if (docSnapshot2.exists) {
    Map<String, dynamic>? data = docSnapshot2.data();
    type = data!['order_type'].toString();
    type != '0'
        ? FirebaseFirestore.instance
            .collection('mp_users')
            .doc(driver.uid)
            .update({
            // "current_order_driver": null,
            "driver_cancelled_trip": FieldValue.increment(1),
          })
        : FirebaseFirestore.instance
            .collection('mp_users')
            .doc(driver.uid)
            .update({
            // "current_order_driver": null,
            "driver_cancelled_delivery": FieldValue.increment(1),
          });
  }
}
