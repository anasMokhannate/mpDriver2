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

class VerifyIdentityController extends GetxController {
  RxBool loading = false.obs;
  MpUser? userBase;
  RxBool isDriver = false.obs;
  XFile? cardFile, cardLicence, cardAssurance, cardGrise, cardAnthropometrique;
  String cardExpire = "Date d'expiration",
      licenceExpire = "Date d'expiration",
      assuranceExpire = "Date d'expiration",
      griseExpire = "Date d'expiration";
  File? card, licence, assurance, grise, anthropometrique;

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
    if (cardExpire == 'Date d\'expiration' ||
        licenceExpire == 'Date d\'expiration' ||
        assuranceExpire == 'Date d\'expiration' ||
        griseExpire == 'Date d\'expiration' ||
        cardFile == null ||
        cardAssurance == null ||
        cardGrise == null ||
        cardLicence == null) {
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
    // if (isCoursier == false && isDriver == false) {
    //   showAlertDialogOneButton(context, 'Données requises',
    //       'Vous devez entrer toutes les données requises.', 'Ok');
    // } else {
    loading.toggle();
    update();
    await uploadImage(context);
    // loading.toggle();
    // update();
  }
  
  uploadImage(context) async {
    if (isDriver.value == true) {
      await FirebaseStorage.instance
          .ref('test-images/user-images/${cardFile!.name}')
          .putFile(card!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) async {
          userBase!.identityCardPicture = value;
          userBase!.identityCardExpirationDate = cardExpire;
        });
      });
      await FirebaseStorage.instance
          .ref('test-images/user-images/${cardLicence!.name}')
          .putFile(licence!)
          .then((p4) {
        p4.ref.getDownloadURL().then((value) async {
          userBase!.drivingLicencePicture = value;
          userBase!.drivingLicenceExpirationDate = licenceExpire;
        });
      });

      await FirebaseStorage.instance
          .ref('test-images/user-images/${cardAssurance!.name}')
          .putFile(assurance!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) async {
          userBase!.assurancePicture = value;
          userBase!.assuranceExpirationDate = assuranceExpire;
        });
      });
      await FirebaseStorage.instance
          .ref('test-images/user-images/${cardGrise!.name}')
          .putFile(grise!)
          .then((p2) {
        p2.ref.getDownloadURL().then((value) async {
          userBase!.carteGrisePicture = value;
          userBase!.carteGriseExpirationDate = griseExpire;
          if (cardAnthropometrique != null) {
            await FirebaseStorage.instance
                .ref('test-images/user-images/${cardAnthropometrique!.name}')
                .putFile(anthropometrique!)
                .then((p1) {
              p1.ref.getDownloadURL().then((value) async {
                userBase!.anthropometrique = value;
                userBase!.currentPageDriver = 'congratsPage';
                userBase!.isDriver = true;
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

                userBase!.isOnline = false; 
                await saveCurrentUser(userBase!).then((value) {
                  completeUser(userBase!).then((value) {
                    Get.offAll(() => Congrats(),
                        transition: Transition.rightToLeft);
                    loading.toggle();
                    update();
                  });
                });
              });
            });
          } else {
            // userBase!.isVerifiedAccount = true;
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
            userBase!.isOnline = false; 
            await saveCurrentUser(userBase!).then((value) {
              completeUser(userBase!).then((value) {
                Get.offAll(() => Congrats(),
                    transition: Transition.rightToLeft);
                loading.toggle();
                update();
              });
            });
          }
        });
      });
    } else {
      loading.toggle();
      update();

      showAlertDialogOneButton(context, "Obligatoire",
          "Veuillez choisir votre type de travail.", "Ok");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserFromMemory().then((value) async {
      userBase = value;
    });

    update();
  }
}
