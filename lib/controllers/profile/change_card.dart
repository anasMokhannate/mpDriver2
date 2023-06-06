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
  bool cardEdited = false,
      licenceEdited = false,
      assuranceEdited = false,
      griseEdited = false,
      antropometriqueEdited = false;
  MpUser? userBase = MpUser();
  bool isOpen = false, isCoursier = false, isDriver = false;
  XFile? cardFile, cardLicence, cardAssurance, cardGrise, cardAnthropometrique;
  String cardExpire = "Date d'expiration",
      licenceExpire = "Date d'expiration",
      assuranceExpire = "Date d'expiration",
      griseExpire = "Date d'expiration";

  // String? currCard, currLicence, currAssurance, currGrise, currAnthropometrique;
  File? card, licence, assurance, grise, anthropometrique;

  selectImageCard() async {
    try {
      cardFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardFile != null) {
        card = File(cardFile!.path);
        cardEdited = true;
        update();
      }
    } catch (e) {
      
    }
  }

  selectImageAnthropometrique() async {
    try {
      cardAnthropometrique =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardAnthropometrique != null) {
        anthropometrique = File(cardAnthropometrique!.path);
        antropometriqueEdited = true;
        update();
      }
    } catch (e) {
      rethrow;
    }
  }

  selectImageAssurance() async {
    try {
      cardAssurance =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardAssurance != null) {
        assurance = File(cardAssurance!.path);
        assuranceEdited = true;
        update();
      }
    } catch (e) {
      
    }
  }

  selectImageGrise() async {
    try {
      cardGrise = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardGrise != null) {
        grise = File(cardGrise!.path);
        griseEdited = true;
        update();
      }
    } catch (e) {
      
    }
  }

  selectImageLicence() async {
    try {
      cardLicence = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (cardLicence != null) {
        licence = File(cardLicence!.path);
        licenceEdited = true;
        update();
      }
    } catch (e) {
      
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

  uploadImages() async {
    FirebaseStorage fs = FirebaseStorage.instance;
    bool isEdited = false;

    if (cardEdited) {
      await fs
          .ref('user-images/${cardFile!.name}')
          .putFile(card!)
          .then((p0) async {
        await p0.ref.getDownloadURL().then((value) async {
          // currCard = value;
          userBase!.identityCardPicture = value;
          userBase!.identityCardExpirationDate = cardExpire;
          isEdited = true;
        });
      });
    }

    if (licenceEdited) {
      await fs
          .ref('user-images/${cardLicence!.name}')
          .putFile(licence!)
          .then((p4) async {
        await p4.ref.getDownloadURL().then((value) async {
          // currLicence = value;
          userBase!.drivingLicencePicture = value;
          userBase!.drivingLicenceExpirationDate = licenceExpire;
          isEdited = true;
        });
      });
    }

    if (assuranceEdited) {
      await fs
          .ref('user-images/${cardAssurance!.name}')
          .putFile(assurance!)
          .then((p0) async {
        await p0.ref.getDownloadURL().then((value) async {
          // currAssurance = value;
          userBase!.assurancePicture = value;
          userBase!.assuranceExpirationDate = assuranceExpire;
          isEdited = true;
        });
      });
    }

    if (griseEdited) {
      await fs
          .ref('user-images/${cardGrise!.name}')
          .putFile(grise!)
          .then((p2) async {
        await p2.ref.getDownloadURL().then((value) async {
          // currGrise = value;
          userBase!.carteGrisePicture = value;
          userBase!.carteGriseExpirationDate = griseExpire;
          isEdited = true;
        });
      });
    }

    if (antropometriqueEdited) {
      await fs
          .ref('user-images/${cardAnthropometrique!.name}')
          .putFile(anthropometrique!)
          .then((p1) async {
        await p1.ref.getDownloadURL().then((value) async {
          // currAnthropometrique = value;
          userBase!.anthropometrique = value;
          isEdited = true;
        });
      });
    }

    return isEdited;
  }

  updateUserImages() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String datenow = dateFormat.format(DateTime.now());

    userBase!.lastDocumentUpdateDate = datenow;
    userBase!.isActivatedAccount = false;
    userBase!.currentPageDriver = "congratsPage";

    await saveCurrentUser(userBase!).then((value) async {
      await completeUser(userBase!).then((value) {
        loading.toggle();
        update();
        Get.offAll(() => Congrats(), transition: Transition.rightToLeft);
      });
    });
  }

  submit(context) async {
    if (isCoursier == false && isDriver == false) {
      showAlertDialogOneButton(context, 'Données requises',
          'Vous devez entrer toutes les données requises.', 'Ok');
    } else {
      loading.toggle();
      update();
      await uploadImages().then((isEdited) async {
        // 
        // 
        // 
        // 
        // 
        // 
        if (isEdited) {
          
          updateUserImages();
        } else {
          
          loading.toggle();
          update();
          Get.offAll(() => ProfilePage(), transition: Transition.rightToLeft);
        }
      });
    }
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

      // currAnthropometrique = value!.anthropometrique!;
      // currCard = value.identityCardPicture!;
      // currLicence = value.drivingLicencePicture!;
      // currAssurance = value.assurancePicture!;
      // currGrise = value.carteGrisePicture!;

      cardExpire = value!.identityCardExpirationDate!;
      licenceExpire = value.drivingLicenceExpirationDate!;
      assuranceExpire = value.assuranceExpirationDate!;
      griseExpire = value.carteGriseExpirationDate!;

      // card = File(value.identityCardPicture!);
      // licence = File(value.drivingLicencePicture!);
      // assurance = File(value.assurancePicture!);
      // grise = File(value.carteGrisePicture!);
      // anthropometrique = File(value.anthropometrique!);
      update();
    });
  }
}
