import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/models/ListItems.dart';

import '../../views/completeYourProfile/adding_photo_moto.dart';

class AddingMotoController extends GetxController {
  var loading;

  var isTrue;

  var marque;

  var modele;

  var imma;

  var color;

  var dropdowntypeItems;

  var type;

  void dropDownMenuChange(ListItem? value) {}

  void submit(BuildContext context) async {
    await Get.to(() => AddingPhotoMoto());
  }
}
