// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/models/ListItems.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/phone_number.dart';
import '../../views/completeYourProfile/upload_image.dart';

class CompleteProfileController extends GetxController {
  RxBool loading = false.obs;
  RxBool isTrue = false.obs;
  MpUser? userBase = MpUser();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController cni = TextEditingController();

  String birthday = "Entrez votre date de naissance";
  String? phoneNumber;
  bool isValid = false;
  bool shown = true;
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

  void submit(BuildContext context) {
    validate(context).then((value) async {
      if (value) {
        loading.toggle();
        update();
        print("heeeeeeeeeeeeeeeeeeeeeere 11111");
        userBase!.uid = FirebaseAuth.instance.currentUser!.uid;
        userBase!.fullName = fullname.text;
        userBase!.email = email.text;
        userBase!.fcmList = <String>[]; //fcmList;
        userBase!.dateNaissance = birthday;
        userBase!.identityCardNumber = cni.text;
        userBase!.sexe = sexe!.value;
        userBase!.currentCity = selected;
        print(
                'user from memory (before complete profile): ${userBase?.email} ${userBase?.authType}');
        if (userBase!.authType == "Phone") {
          print("heeeeeeeeeeeeeeeeeeeeeere 22222");
          userBase!.currentPageClient = "uploadImage";
          userBase!.currentPageDriver = 'uploadImage';
          await saveCurrentUser(userBase!).then((value) async {
            print(
                'user from memory (complete profile): ${userBase?.email} ${userBase?.authType}');
            await completeUser(userBase!).then((value) {
              print("heeeeeeeeeeeeeeeeeeeeeere 33333");
              loading.toggle();
              update();
              print("heeeeeeeeeeeeeeeeeeeeeere 44444");
              Get.to(() => UploadImage(), transition: Transition.rightToLeft);
              
              // } else {
              //   showAlertDialogOneButton(
              //       context, "Erreur", "Réssayez plus tard", "Ok");
              // }
            });
          });
        } else if (userBase!.authType == "Google") {
          userBase!.currentPageClient = "verifyPhoneNumber";
          userBase!.currentPageDriver = "verifyPhoneNumber";
          await saveCurrentUser(userBase!).then((value) async {
            await completeUser(userBase!).then((userUpdated) {
              loading.toggle();
              update();
              Get.to(() => VerifyPhoneNumber(),
                  transition: Transition.rightToLeft);
              // } else {
              //   showAlertDialogOneButton(
              //       context, "Erreur", "Réssayez plus tard", "Ok");
              // }
            });
          });
        }
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) {
      userBase = value;
    });
    print("tesst: currentUser: ${userBase!.email}");
    await SessionManager().get("email").then((value) {
      print('tesst: email: $value');
    });
    email.text = userBase!.email ?? await SessionManager().get('email');
    phoneNumber = await SessionManager().get('phone');
    dropdownSexeItems = buildDropDownMenuItems(sexeItems);
    sexe = dropdownSexeItems![0].value;
    isTrue.toggle();
    update();
  }
}
