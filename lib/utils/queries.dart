// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:motopickupdriver/utils/models/config-params.dart';
import 'package:motopickupdriver/utils/models/emergency.dart';
import 'package:motopickupdriver/utils/models/user.dart';

Future createUser(MpUser user) async {
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);

  await docUser.set(user.toJson());
}

Future<String> getProvider(String email) async {
  String provider = "";
  await FirebaseFirestore.instance
      .collection("mp_users")
      .where("email", isEqualTo: email)
      .where("is_deleted_account", isEqualTo: false)
      //  .where("is_driver", isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    provider = value.docs.first.get("auth_type");
  });
  print('provider: $provider');
  return provider;
}

Future completeUser(MpUser user) async {
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);
  await docUser.update(user.toJson());
}

Future<int> getUserStatus(uid) async {
  int status = 4;
  await getUser(uid).then((value) async {
    if (!value.isVerifiedAccount!) status = 0;
    if (!value.isVerifiedAccount! && value.isActivatedAccount!) status = 1;
    if (value.isVerifiedAccount!) status = 2;
  });

  return status;
}

Future<MpUser> getUser(uid) async {
  MpUser? user;
  var docSnapshot =
      await FirebaseFirestore.instance.collection('mp_users').doc(uid).get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    user = MpUser.fromJson(data!);
  }
  return user!;
}

Future<String> checkPhoneNumber(phoneNo) async {
  String message = "";

  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) {
      message = "found";
    }
    else{
      message = "not-found";
    }
  });

  return message;
}

Future<String> checkPhoneNumber2(phoneNo) async {
  String message = "not-found";

  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) message = "found";
  });

  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) message = "found";
  });

  return message;
}

Future<String> loginWithPhone(phone) async {
  String? email;
  try {
    await FirebaseFirestore.instance
        .collection('mp_users')
        .where('phone_number', isEqualTo: phone)
        .where('is_deleted_account', isEqualTo: false)
        .snapshots()
        .first
        .then((value) {
      email = value.docs.first.get('email');
    });
  }  
  catch (e) {
    email = 'usernoexistawsa@gmail.com';
  }

  return email!;
}

Future deleteUser(MpUser user, reason) async {
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);

  await docUser.update({
    'is_deleted_account': true,
    // 'reason_for_delete': reason ?? '-',
    'is_activated_account': false,
    'is_verified_account': false
  });
}

Future createEmergency(Emergency emergency) async {
  final docUser =
      FirebaseFirestore.instance.collection('emergency').doc(emergency.user);

  await docUser.set(emergency.toJson());
}

Future addDriverToOrder(MpUser driver, orderId) async {
  final fcm = await SessionManager().get('driver_fcm');
  //driver.driver_fcm = fcm;
  final docUser = FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .collection('mp_users')
      .add(driver.toJson());

  FirebaseFirestore.instance.collection('orders').doc(orderId).update(({
        'mp_users_accepted': FieldValue.arrayUnion([driver.uid])
      }));
}

Future<bool> checkEmail(email) async {
  bool message = false;
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('email', isEqualTo: email)
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

Future<bool> isUserExist(phoneNo) async {
  bool exist = false;
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) exist = true;
  });
  return exist;
}

Future<List<MotoType>> getData() async {
  final value = await FirebaseFirestore.instance
      .collection('config')
      .doc('config-params')
      .get();

  MotoType motoTypeT1 = MotoType.fromJson(value.get('T1'));
  MotoType motoTypeT2 = MotoType.fromJson(value.get('T2'));
  MotoType motoTypeT3 = MotoType.fromJson(value.get('T3'));
  List<MotoType> motos = [];
  motos.addAll({motoTypeT1, motoTypeT2, motoTypeT3});
  return motos;
}

// Future refuserOrder(MpUser driver, orderId) async {
//   FirebaseFirestore.instance.collection('orders').doc(orderId).update(({
//         'is_canceled_by_driver': true,
//         'status': 0,
//         'mp_users_declined': FieldValue.arrayUnion([driver.uid])
//       }));
//   String type = "";
//   var docSnapshot2 =
//       await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
//   if (docSnapshot2.exists) {
//     Map<String, dynamic>? data = docSnapshot2.data();
//     type = data!['order_type'].toString();
//     type != '0'
//         ? FirebaseFirestore.instance
// <<<<<<< HEAD
//             .collection('mp_users')
// =======
//             .collection('drivers')
// >>>>>>> 5d5bfe6e3264c80d1268b8e92b4d5a0246cd1ab2
//             .doc(driver.uid)
//             .update({
//             "is_on_order": false,
//             "driver_cancelled_trip": FieldValue.increment(1),
//           })
//         : FirebaseFirestore.instance
// <<<<<<< HEAD
//             .collection('mp_users')
// =======
//             .collection('drivers')
// >>>>>>> 5d5bfe6e3264c80d1268b8e92b4d5a0246cd1ab2
//             .doc(driver.uid)
//             .update({
//             "is_on_order": false,
//             "driver_cancelled_delivery": FieldValue.increment(1),
//           });
//   }
// }

Future updateStatusOrder(orderId) async {
  FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .update({"is_start": true});
}

Future updateSuccedOrder(orderId) async {
  FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .update({"is_succeed": true, 'status': 1});
}

Future<bool> userExist(uid) async {
  bool exist = false;
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('driver_uid', isEqualTo: uid)
      .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) exist = true;
  });
  return exist;
}
