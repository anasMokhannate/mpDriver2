import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motopickupdriver/utils/navigations.dart';
import 'package:motopickupdriver/utils/services.dart';

import '../utils/alert_dialog.dart';
import '../utils/models/user.dart';
import '../utils/queries.dart';
import '../views/completeYourProfile/complete_profile.dart';
// import 'package:motopickup/views/completeYourProfile/complete_profile_page.dart';
// import 'package:motopickup/views/home_page.dart';

class WelcomeController extends GetxController {
  RxBool loading = false.obs;
  MpUser? mpUser;

  void googleAuth(context) async {
    await GoogleSignIn().signOut();
    loading.toggle();
    update();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      await getProvider(googleUser.email).then((provider) async {
        if (provider != "Google" && provider != "") {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          loading.toggle();
          update();
          showAlertDialogOneButton(
              context,
              "Utilisateur existe déjà",
              "Il existe déjà un compte avec cet e-mail, veuillez essayer de vous connecter avec $provider",
              "Ok");
        } else {
          GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential result =
              await FirebaseAuth.instance.signInWithCredential(credential);
          User? user = result.user;

          if (provider == "") {
            MpUser mpUser = MpUser(
              uid: user!.uid,
              email: user.email,
              profilePicture: user.photoURL,
              authType: 'Google',
              isActivatedAccount: false,
              currentPageClient: 'completeProfile',
              currentPageDriver: 'completeProfile',
              isDriver: false,
              lastLoginDate: DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
                  .format(DateTime.now()),
              registrationDate: DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
                  .format(DateTime.now()),
              isDeletedAccount: false,
              isVerifiedAccount: false,
              cancelledDelivery: 0,
              cancelledTrip: 0,
              isBlacklistedAccount: false,
              isPasswordChange: false,
              orderTotalAmount: 0.0,
              reportedTimes: 0,
              succededDelivery: 0,
              succededTrip: 0,
              driverTotalOrders: 0,
              customerTotalOrders: 0,
              customerNote: 0,
              driverNote: 0,
            );

            await saveCurrentUser(mpUser);
            await createUser(mpUser).then(
              (value) async {
                Get.offAll(() => CompleteProfile(),
                    transition: Transition.rightToLeft);
              },
            );
          } else {
            await getUser(user?.uid).then((user) async {
              MpUser mpUser = user;
              mpUser.lastLoginDate = DateFormat('dd-MM-yyyy Hh:mm', 'Fr_fr')
                  .format(DateTime.now());
              await completeUser(mpUser).then((value) async {
                await saveCurrentUser(mpUser).then((value) async {
                  await initWidget().then((mainPage) {
                    loading.toggle();
                    update();
                    Get.offAll(
                      () => mainPage as Widget,
                      transition: Transition.rightToLeft,
                    );
                  });
                });
              });
            });
          }
        }
      });
    } else {
      loading.toggle();
      update();
    }
  }

  void facebookAuth(BuildContext context) async {
    loading.toggle();

    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(facebookCredential);
    User? user = authResult.user;
    loading.toggle();
  }

  @override
  void onInit() async {
    super.onInit();

    await SessionManager().get("hasAccepted").then((value) {
      
    });
    await getUserFromMemory().then((value) {
      
    });
    SessionManager().remove('currentUser');
    await getUserFromMemory().then((value) {
      
    });
  }
}
