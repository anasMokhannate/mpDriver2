import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/ListItems.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/queries.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/models/config-params.dart';
import '../../utils/models/moto.dart';
import '../../utils/services.dart';
import '../../views/completeYourProfile/adding_photo_moto.dart';

class AddingMotoController extends GetxController {
  RxBool loading = false.obs;
  RxBool isTrue = false.obs;

  TextEditingController marque = TextEditingController();
  TextEditingController modele = TextEditingController();
  TextEditingController imma = TextEditingController();
  TextEditingController color = TextEditingController();

  List<DropdownMenuItem<ListItem>>? dropdowntypeItems;
  ListItem? type;
  List<ListItem> typeItems = [
    ListItem("-", "Sélectionnez Type"),
  ];

  MpUser? userBase;

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
    });
    await getMoto();
    dropdowntypeItems = buildDropDownMenuItems(typeItems);
    type = dropdowntypeItems![0].value;
    isTrue.toggle();
    update();
  }

  dropDownMenuChange(value) {
    type = value;
  }

  Future getMoto() async {
    final value = await FirebaseFirestore.instance
        .collection('config')
        .doc('config-params')
        .get();

    MotoType motoTypeT1 = MotoType.fromJson(value.get('T1'));
    MotoType motoTypeT2 = MotoType.fromJson(value.get('T2'));
    MotoType motoTypeT3 = MotoType.fromJson(value.get('T3'));

    typeItems.add(ListItem('T1', motoTypeT1.name));
    typeItems.add(ListItem('T2', motoTypeT2.name));
    typeItems.add(ListItem('T3', motoTypeT3.name));
    update();
  }

  Future<bool> validate(context) {
    bool isValid = true;
    if (marque.text.isEmpty ||
        modele.text.isEmpty ||
        imma.text.isEmpty ||
        color.text.isEmpty ||
        type!.value == '-') {
      showAlertDialogOneButton(context, 'Données requises',
          'Vous devez entrer toutes les données requises.', 'Ok');
      isValid = false;
    }
    return Future.value(isValid);
  }

  void submit(BuildContext context) async {
    // FirebaseAuth.instance.signOut();
    // SessionManager().destroy();
    // Get.to(() => WelcomeScreen());

    await validate(context).then((value) async {
      if (value) {
        Moto moto = Moto(
            motocycle_brand: marque.text,
            motocycle_model: modele.text,
            motocycle_imm: imma.text,
            motocycle_color: color.text,
            motocycle_type: type!.value,
            motocycle_status: true);
        if (userBase!.motos == null) {
          userBase!.motos = [];
        }

        userBase!.motos!.add(moto.toJson());
        userBase!.currentPageDriver = "addingOhotoMoto";
        saveCurrentUser(userBase!);
        completeUser(userBase!);

        await Get.to(() => AddingPhotoMoto(),
            transition: Transition.leftToRight);
      }
    });
  }
}
