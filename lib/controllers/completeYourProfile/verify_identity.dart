import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../views/congrats_page.dart';

class VerifyIdentityController extends GetxController{
  var loading;

  var cardFile;

  var card;

  var cardExpire;

  var cardLicence;

  var licence;

  var licenceExpire;

  var cardAssurance;

  var assuranceExpire;

  var cardGrise;

  var griseExpire;

  var cardAnthropometrique;

  var anthropometrique;

  bool isDriver = false;

  get assurance => null;

  get grise => null;

  void selectImageCard() {}

  void selectImageLicence() {}

  void selectImageAssurance() {}

  void selectImageGrise() {}

  void selectImageAnthropometrique() {}

  validat(BuildContext context) {}

  void submit(BuildContext context) {
     Get.offAll(() => Congrats(), transition: Transition.rightToLeft);
  }

}