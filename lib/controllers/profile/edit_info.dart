import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/ListItems.dart';
import 'package:motopickupdriver/views/profile/main_page.dart';

import '../../utils/alert_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/models/user.dart';
import '../../utils/queries.dart';
import '../../utils/services.dart';

class EditInfoController extends GetxController {
  RxBool isTrue = false.obs;
  bool isValid = false;
  MpUser? userBase;

  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();

  String birthday = "Entrez votre date de naissance";

  List<DropdownMenuItem<ListItem>>? dropdownSexeItems;

  ListItem? sexe;

  String message = "";

  final List<ListItem> sexeItems = [
    ListItem("-", "Sélectionnez votre genre"),
    ListItem("male", "Homme"),
    ListItem("female", "Femme"),
  ];

  dropDownMenuChange(value) {
    sexe = value;
  }

  birthdayChange(value) {
    birthday = DateFormat('dd-MM-yyyy').format(value).toString();
  }

  Future<bool> validate(context) async {
    if (fullname.text.trim().isEmpty ||
        fullname.text.length < 4 ||
        birthday == "Entrez votre date de naissance" ||
        sexe!.value == '-') {
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
        isTrue.toggle();
        update();

        // userBase!.uid = FirebaseAuth.instance.currentUser!.uid;
        userBase!.fullName = fullname.text;
        // userBase!.email = email.text;
        userBase!.dateNaissance = birthday;
        userBase!.sexe = sexe!.value;

        await saveCurrentUser(userBase!).then((value) async {
          await completeUser(userBase!).then((userUpdated) {
            isTrue.toggle();
            update();
            Get.to(() => ProfilePage(),
                transition: Transition.rightToLeft);
            showAchievementView(context, "Informations mises à jour avec succès", "Vos informations ont été mises à jour avec succès.");
          });
        });
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      fullname.text = userBase!.fullName!;
      email.text = userBase!.email!;
      birthday = userBase!.dateNaissance!;
      dropdownSexeItems = buildDropDownMenuItems(sexeItems);
      userBase!.sexe == 'male'
          ? sexe = dropdownSexeItems![1].value
          : sexe = dropdownSexeItems![2].value;
      isTrue.toggle();
      update();
    });
  }
}
