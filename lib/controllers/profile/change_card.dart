// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/models/user.dart';
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/services.dart';
import 'package:motopickupdriver/views/congrats_page.dart';
import 'package:motopickupdriver/views/profile/main_page.dart';

class ChangeCardController extends GetxController {
  RxBool loading = false.obs;
  MpUser? userBase;
  bool isOpen = false, isCoursier = false, isDriver = false;
  XFile? cardFile, cardLicence, cardAssurance, cardGrise, cardAnthropometrique;
  String cardExpire = 'Date d\'expiration',
      licenceExpire = "Date d'expiration",
      assuranceExpire = "Date d'expiration",
      griseExpire = "Date d'expiration";
  File? card, licence, assurance, grise, anthropometrique;

  selectImageCard() async {
    try {
      cardFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardFile != null) {
        card = File(cardFile!.path);
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  selectImageAnthropometrique() async {
    try {
      cardAnthropometrique =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardAnthropometrique != null) {
        anthropometrique = File(cardAnthropometrique!.path);
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  selectImageAssurance() async {
    try {
      cardAssurance =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardAssurance != null) {
        assurance = File(cardAssurance!.path);
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  selectImageGrise() async {
    try {
      cardGrise = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardGrise != null) {
        grise = File(cardGrise!.path);
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  selectImageLicence() async {
    try {
      cardLicence = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardLicence != null) {
        licence = File(cardLicence!.path);
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> validat(context) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd ");

    String datenow = dateFormat.format(DateTime.now());
    bool isValid = true;
    if (cardExpire == 'Date d’expiration' ||
        licenceExpire == 'Date d’expiration' ||
        assuranceExpire == 'Date d’expiration' ||
        griseExpire == 'Date d’expiration') {
      isValid = false;
      showAlertDialogOneButton(context, 'Données requises',
          'Vous devez entrer toutes les données requises.', 'Ok');
    } else if (cardExpire.compareTo(datenow) <= 0 ||
        licenceExpire.compareTo(datenow) <= 0 ||
        assuranceExpire.compareTo(datenow) <= 0 ||
        griseExpire.compareTo(datenow) <= 0) {
      isValid = false;

      showAlertDialogOneButton(context, 'Les dates sont expirées',
          'Vous devez entrer des dates valides .', 'Ok');
    }
    return isValid;
  }

  submit(context) async {
    if (isCoursier == false && isDriver == false) {
      showAlertDialogOneButton(context, 'Données requises',
          'Vous devez entrer toutes les données requises.', 'Ok');
    } else {
      loading.toggle();
      update();
      await uploadImage();
      loading.toggle();
      update();
    }
  }

  uploadImage() async {
    await FirebaseStorage.instance
        .ref('user-images/${cardFile!.name}')
        .putFile(card!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        userBase!.identityCardPicture = value;
        userBase!.identityCardExpirationDate = cardExpire;
      });
    });
    await FirebaseStorage.instance
        .ref('user-images/${cardLicence!.name}')
        .putFile(licence!)
        .then((p4) {
      p4.ref.getDownloadURL().then((value) async {
        userBase!.drivingLicencePicture = value;
        userBase!.drivingLicenceExpirationDate = licenceExpire;
      });
    });

    await FirebaseStorage.instance
        .ref('user-images/${cardAssurance!.name}')
        .putFile(assurance!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        userBase!.assurancePicture = value;
        userBase!.assuranceExpirationDate = assuranceExpire;
      });
    });
    await FirebaseStorage.instance
        .ref('user-images/${cardGrise!.name}')
        .putFile(grise!)
        .then((p2) {
      p2.ref.getDownloadURL().then((value) async {
        userBase!.carteGrisePicture = value;
        userBase!.carteGriseExpirationDate = griseExpire;
        if (cardAnthropometrique != null) {
          await FirebaseStorage.instance
              .ref('user-images/${cardAnthropometrique!.name}')
              .putFile(anthropometrique!)
              .then((p1) {
            p1.ref.getDownloadURL().then((value) async {
              userBase!.anthropometrique = value;

              // userBase!.isVerifiedAccount = true;
              // if (isCoursier == true && isDriver == false) {
              //   userBase!.isDriver = 1;
              // }
              // if (isCoursier == false && isDriver == true) {
              //   userBase!.is_driver = 2;
              // }
              // if (isCoursier == true && isDriver == true) {
              //   userBase!.is_driver = 3;
              // }
              // userBase!.isActivatedAccount = false;
              DateFormat dateFormat = DateFormat("yyyy-MM-dd ");

              String datenow = dateFormat.format(DateTime.now());

              userBase!.lastDocumentUpdateDate = datenow;
              await saveCurrentUser(userBase!);
              completeUser(userBase!).then((value) {
                Get.offAll(() => ProfilePage(),
                    transition: Transition.rightToLeft);
                loading.toggle();
                update();
              });
            });
          });
        } else {
          // userBase!.is_verified_account = true;
          // if (isCoursier == true && isDriver == false) {
          //   userBase!.is_driver = 1;
          // }
          // if (isCoursier == false && isDriver == true) {
          //   userBase!.is_driver = 2;
          // }
          // if (isCoursier == true && isDriver == true) {
          //   userBase!.is_driver = 3;
          // }
          // userBase!.isActivatedAccount = false;
          DateFormat dateFormat = DateFormat("yyyy-MM-dd ");

          String datenow = dateFormat.format(DateTime.now());

          userBase!.lastDocumentUpdateDate = datenow;
          await saveCurrentUser(userBase!);
          completeUser(userBase!).then((value) {
            Get.offAll(() => Congrats(), transition: Transition.rightToLeft);
            loading.toggle();
            update();
          });
        }
      });
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
      // cardFile = XFile(value!.identityCardPicture!);
      // card = File(cardFile!.path);
      // cardLicence = XFile(value.drivingLicencePicture!);
      // licence = File(cardLicence!.path);
      // cardAssurance = XFile(value.assurancePicture!);
      // assurance = File(cardAssurance!.path);
      // cardGrise = XFile(value.carteGrisePicture!);
      // grise = File(cardGrise!.path);
      // cardAnthropometrique = XFile(value.anthropometrique!);
      // anthropometrique = File(cardAnthropometrique!.path);

      // cardFile = XFile("");
      // cardLicence = XFile("");
      // cardAssurance = XFile("");
      // cardGrise = XFile("");
      // cardAnthropometrique = XFile("");

      cardExpire = value!.identityCardExpirationDate!;
      licenceExpire = value.drivingLicenceExpirationDate!;
      assuranceExpire = value.assuranceExpirationDate!;
      griseExpire = value.carteGriseExpirationDate!;

      card = File(value.identityCardPicture!);
      licence = File(value.drivingLicencePicture!);
      assurance = File(value.assurancePicture!);
      grise = File(value.carteGrisePicture!);
      anthropometrique = File(value.anthropometrique!);
      update();
    });
  }
}
