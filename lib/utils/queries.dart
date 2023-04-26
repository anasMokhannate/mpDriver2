import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'models/user.dart';

Future<String> checkPhoneNumber(phoneNo) async {
  String message = "not-found";

  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('phone_number', isEqualTo: phoneNo)
      // .where('auth_type', whereIn: ["Phone", "Facebook", "Google"])
      // .where('is_deleted_account', isEqualTo: false)
      .snapshots()
      .first
      .then((value) {
    if (value.size != 0) message = "found-in-users";
  });
  return message;
}

Future<bool> checkEmail(email) async {
  bool message = false;
  //String message = "not-found";
  await FirebaseFirestore.instance
      .collection('mp_users')
      .where('email', isEqualTo: email)
      //.where('auth_type', whereIn: ["Phone", "Facebook", "Google"])
      // .where('is_deleted_account', isEqualTo: false)
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
  Get.snackbar('Error', 'start of creating user');
  final docUser =
      FirebaseFirestore.instance.collection('mp_users').doc(user.uid);
  await docUser.set(user.toJson()).then((value) => 'null',
      onError: (error) =>
          '${error}erroooooooooooooooooooooooooooooor');
  Get.snackbar('title', 'User created');
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

Future<String> getProvider(String email) async {
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
    provider = value.docs.first.get("auth_type");
  });
  print('provider: $provider');
  return provider;
}

Future<String> loginWithPhone(phone) async {
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
  print(email);
  return email!;
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
