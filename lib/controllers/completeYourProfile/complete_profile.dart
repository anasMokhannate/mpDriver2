// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';


import '../../utils/alert_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/models/ListItems.dart';
import '../../utils/models/user.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/upload_image.dart';

class CompleteProfileController extends GetxController {
  RxBool loading = false.obs;
  RxBool isTrue = false.obs;
  MpUser? userBase = MpUser();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  String birthday = "Entrez votre date de naissance";
  String? phoneNumber;
  bool isValid = false;
  int? initialData;
  var selected;
  List? selectedList;
  DateTime currentDate = DateTime.now().subtract(const Duration(days: 6570));

  List<DropdownMenuItem<ListItem>>? dropdownSexeItems;
  ListItem? sexe;
  final List<ListItem> sexeItems = [
    ListItem("-", "Sélectionnez votre genre"),
    ListItem("male", "Homme"),
    ListItem("female", "Femme"),
  ];

  var shown;

  var cni;

  dropDownMenuChange(value) {
    sexe = value;
  }

  cityPickerChange(value) {
    if (value != null) {
      selected = value['name'].toString();
      initialData = value['key'];
    } else {
      selected = null;
    }
  }

  Future<bool> validate(context) async {
    if (fullname.text.trim().isEmpty ||
        fullname.text.length < 4 ||
        email.text.isEmpty ||
        birthday == "Entrez votre date de naissance" ||
        sexe!.value == '-' ||
        selected == null) {
      showAlertDialogOneButton(context, 'Données requises',
          'Vous devez entrer toutes les données requises.', 'Ok');
      isValid = false;
    } else if (fullname.text.trim().contains(regExp)) {
      showAlertDialogOneButton(context, 'Nom invalide',
          'le nom ne doit pas contenir les caractères spéciaux.', 'Ok');
      isValid = false;
    } else if (fullname.text.trim().length > 50) {
      showAlertDialogOneButton(context, 'Données requises',
          'le nom ne doit pas contenir les caractères spéciaux.', 'Ok');
      isValid = false;
    } else {
      isValid = true;
    }
    return isValid;
  }

//=========================== old submit ============================
  // submit(context) {
  //   validate(context).then((value) async {
  //     if (value) {
  //       loading.toggle();
  //       update();
  //       // await FirebaseFirestore.instance
  //       //     .collection('mp_users')
  //       //     .where('email', isEqualTo: email.text)
  //       //     .where('auth_type', isEqualTo: 'Phone')
  //       //     .where('is_deleted_account', isEqualTo: false)
  //       //     .snapshots()
  //       //     .first
  //       //     .then((value) async {
  //       //   if (value.size != 0) {
  //       //     loading.toggle();
  //       //     update();
  //       //     return showAlertDialogOneButton(
  //       //         context,
  //       //         "Email déjà utilisé",
  //       //         "Veuillez changer l'adresse e-mail, l'adresse e-mail que vous avez entré est déjà utilisé.",
  //       //         "Ok");
  //       //   } else {
  //       //     userBase!.fullName = fullname.text;
  //       //     userBase!.email = email.text.toLowerCase();
  //       //     userBase!.dateNaissance = birthday;
  //       //     userBase!.sexe = sexe!.value;
  //       //     userBase!.currentCity = selected;
  //       //     //  List cities = userBase!.used_cities.toList();
  //       //     // cities.clear();
  //       //     //  cities.add(selected);
  //       //     // userBase!.used_cities = cities;
  //       //     await SessionManager().set('currentUser', userBase);
  //       //     loading.toggle();
  //       //     update();
  //       //     // userBase!.authtype == 'Phone'
  //       //     // ? Get.to(() => UploadImage(),
  //       //     //     transition: Transition.rightToLeft)
  //       //     // : Get.to(() => VerifyPhoneNumber(),
  //       //     //     transition: Transition.rightToLeft);
  //       //   }
  //       // });

  //       userBase!.uid = FirebaseAuth.instance.currentUser!.uid;
  //       userBase!.fullName = fullname.text;
  //       userBase!.email = email.text;
  //       userBase!.phoneNumber = phoneNumber;
  //       userBase!.dateNaissance = birthday;
  //       userBase!.sexe = sexe!.value;
  //       userBase!.currentCity = selected;
  //       userBase!.currentPage = "uploadImage";
  //       userBase!.authtype = "Phone";
  //       await SessionManager().set('currentUser', userBase);
  //       completeUser(userBase!);
  //       loading.toggle();
  //       update();
  //       userBase!.authtype == 'Phone'
  //           ? Get.to(() => UploadImage(), transition: Transition.rightToLeft)
  //           : null;
  //       // : Get.to(() => VerifyPhoneNumber(),
  //       //     transition: Transition.rightToLeft);
  //     }
  //   });
  // }
  //=========================== old submit ============================

  void submit(BuildContext context) {
    // validate(context).then((value) async {
    //   if (value) {
    //     loading.toggle();
    //     update();

    //     userBase!.uid = FirebaseAuth.instance.currentUser!.uid;
    //     userBase!.fullName = fullname.text;
    //     userBase!.email = email.text;
    //     userBase!.dateNaissance = birthday;
    //     userBase!.sexe = sexe!.value;
    //     userBase!.currentCity = selected;
    //     if (userBase!.authType == "Phone") {
    //       userBase!.currentPage = "uploadImage";
    //       await SessionManager().set('currentUser', userBase).then((value) {
    //         completeUser(userBase!);
    //         loading.toggle();
    //         update();
    //         Get.to(() => UploadImage(), transition: Transition.rightToLeft);
    //       });
    //     } else if (userBase!.authType == "Google") {
    //       userBase!.currentPage = "verifyPhoneNumber";
    //       await SessionManager().set('currentUser', userBase).then((value) {
    //         completeUser(userBase!);
    //         loading.toggle();
    //         update();
    //         Get.to(() => VerifyPhoneNumber(), transition: Transition.rightToLeft);
    //       });

    //     }
    //   }
    // });
                  Get.to(() => UploadImage(), transition: Transition.rightToLeft);

  }

  @override
  void onInit() async {
    super.onInit();
    userBase = MpUser.fromJson(await SessionManager().get('currentUser'));
    print(userBase);
    email.text = userBase!.email!;
    phoneNumber = await SessionManager().get('phone');
    dropdownSexeItems = buildDropDownMenuItems(sexeItems);
    sexe = dropdownSexeItems![0].value;
    isTrue.toggle();
    update();
  }
}
