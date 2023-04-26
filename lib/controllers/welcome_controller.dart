import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../utils/alert_dialog.dart';
import '../utils/models/user.dart';
import '../utils/queries.dart';
import '../views/completeYourProfile/complete_profile.dart';
import '../views/home_page.dart';
// import 'package:motopickup/views/completeYourProfile/complete_profile_page.dart';
// import 'package:motopickup/views/home_page.dart';

class WelcomeController extends GetxController {
  RxBool loading = false.obs;
  MpUser? mpUser;

  void googleAuth(context) async {
     //await GoogleSignIn().signOut();
    loading.toggle();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = result.user;
      await isUserExist(user!.uid).then((exist) async {
        if (exist) {
          await getUser(user.uid).then((user) async {
            await getProvider(user.email!).then((provider) async {
              if (provider != "Google" && provider != "") {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                showAlertDialogOneButton(
                    context,
                    "Utilisateur existe déjà",
                    "Il existe déjà un compte avec cet e-mail, veuillez essayer de vous connecter avec $provider",
                    "Ok");
                loading.toggle();
                update();
              } else {
                MpUser mpUser = user;
                //mpUser.authType = "Google";
                mpUser.lastLoginDate = DateFormat('dd-MM-yyyy Hh:mm', 'Fr_fr')
                    .format(DateTime.now());
                //TODO check if profile is complete
                completeUser(mpUser);
                await SessionManager().set('currentUser', mpUser);
                Get.offAll(
                  //TODO use initWidget instead of HomePage
                  () => const HomePage(),
                  transition: Transition.rightToLeft,
                );
              }
            });
          });
        } else {
          MpUser mpUser = MpUser(
              // fullName: user.displayName,
              uid: user.uid,
              email: user.email,
              profilePicture: user.photoURL,
              authType: "Google",
              registrationDate: DateFormat('dd-MM-yyyy Hh:mm', 'Fr_fr')
                  .format(DateTime.now()),
              lastLoginDate: DateFormat('dd-MM-yyyy Hh:mm', 'Fr_fr')
                  .format(DateTime.now()),
              isDeletedAccount: false,
              isDriver: false,
              currentPageClient: "completeProfile");
          await SessionManager().set('currentUser', mpUser);
          await createUser(mpUser).then(
            (value) async {
              Get.offAll(() => CompleteProfile(),
                  transition: Transition.rightToLeft);
            },
          );
        }
        // await FirebaseFirestore.instance
        //     .collection('mp_users')
        //     .doc(user.uid)
        //     .delete();
        // await user.delete();
      });
    } else {
      loading.toggle();
      update();
    }
  }

  // googleAuth(BuildContext context) async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   UserCredential userCred =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   print(userCred.toString());
  //   Get.to(CompleteProfile(), arguments: userCred.user!.email);
  // }

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

  //================================================================================================================================
  //  // RxBool loading = false.obs;

  // void googleAuth(context) async {
  //   // loading.toggle();
  //   // GoogleSignInAccount? googleAccount =
  //   //     await GoogleSignIn(scopes: ['profile', 'email']).signIn();
  //   // if (googleAccount != null) {
  //   //   await isUserExist(googleAccount.email.toLowerCase()).then((value) async {
  //   //     if (value != "Google" && value != "") {
  //   //       await FirebaseAuth.instance.signOut();
  //   //       await GoogleSignIn(scopes: ['profile', 'email']).signOut();
  //   //       return showAlertDialogOneButton(
  //   //           context,
  //   //           "L'utilisateur existe déjà",
  //   //           "Il existe déjà un compte avec cet e-mail, veuillez essayer de vous connecter avec $value",
  //   //           "Ok");
  //   //     } else {
  //   //       GoogleSignInAuthentication googleSignInAuthentication =
  //   //           await googleAccount.authentication;
  //   //       AuthCredential credential = GoogleAuthProvider.credential(
  //   //           accessToken: googleSignInAuthentication.accessToken,
  //   //           idToken: googleSignInAuthentication.idToken);
  //   //       UserCredential authResult =
  //   //           await FirebaseAuth.instance.signInWithCredential(credential);
  //   //       User? user = authResult.user;
  //   //       await getUserFrom(user!.email, "Google").then((message) async {
  //   //         print("this is message: " + message);
  //   //         if (message == "new-account" || message == "is-not-verified") {
  //   //           UserBase userBase = UserBase(
  //   //               customer_uid: user.uid,
  //   //               customer_full_name: user.displayName!,
  //   //               customer_email: user.email!,
  //   //               customer_phone_number: user.phoneNumber ?? '-',
  //   //               customer_picture: user.photoURL!,
  //   //               customer_date_naissance: '',
  //   //               customer_sexe: '',
  //   //               customer_auth_type: 'Google',
  //   //               is_activated_account: false,
  //   //               customer_cancelled_delivery: 0,
  //   //               customer_succeded_delivery: 0,
  //   //               customer_planned_delivery: 0,
  //   //               customer_cancelled_trip: 0,
  //   //               customer_succeded_trip: 0,
  //   //               customer_planned_trip: 0,
  //   //               customer_used_cities: [],
  //   //               customer_note: 0,
  //   //               customer_last_order_state: false,
  //   //               customer_last_login_date:
  //   //                   DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                       .format(DateTime.now()),
  //   //               customer_registration_date:
  //   //                   DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                       .format(DateTime.now()),
  //   //               is_deleted_account: false,
  //   //               is_verified_account: false,
  //   //               customer_city: '',
  //   //               customer_longitude: 0,
  //   //               customer_latitude: 0,
  //   //               customer_total_orders: 0);
  //   //           await SessionManager().set(
  //   //             'tmpUser',
  //   //             TmpUser(
  //   //               phoneNo: '',
  //   //               password: '',
  //   //               email: user.email!,
  //   //               is_exist: false,
  //   //               type_auth: "Google",
  //   //             ),
  //   //           );
  //   //           GetStorage().write('isLoggedIn', true);
  //   //           await SessionManager().set('currentUser', userBase);
  //   //           await createUser(userBase).then(
  //   //             (value) async {
  //   //               updateFcm(userBase);
  //   //               Get.offAll(() => CompleteProfile(),
  //   //                   transition: Transition.rightToLeft);
  //   //             },
  //   //           );
  //   //         }
  //   //         if (message == "is-verified") {
  //   //           await getUserFix(user!.email, "Google").then((value) async {
  //   //             await SessionManager().set(
  //   //               'tmpUser',
  //   //               TmpUser(
  //   //                 phoneNo: value.customer_phone_number,
  //   //                 password: '',
  //   //                 email: user.email!,
  //   //                 is_exist: true,
  //   //                 type_auth: "Google",
  //   //               ),
  //   //             );
  //   //             value.customer_last_login_date =
  //   //                 DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                     .format(DateTime.now());
  //   //             UserBase userBase = value;
  //   //             await completeUser(userBase);
  //   //             await GetStorage().write('isLoggedIn', true);
  //   //             await SessionManager().set('currentUser', userBase);
  //   //             updateFcm(userBase);
  //   //             goToOff(const HomePage());
  //   //             Get.offAll(() => const HomePage(),
  //   //                 transition: Transition.rightToLeft);
  //   //           });
  //   //         }
  //   //       });
  //   //     }
  //   //   });
  //   //   loading.toggle();
  //   // } else {
  //   //   loading.toggle();
  //   // }
  // }

  // void facebookAuth(context) async {
  //   // loading.toggle();
  //   // try {
  //   //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   //   final OAuthCredential facebookAuthCredential =
  //   //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //   //   UserCredential authResult = await FirebaseAuth.instance
  //   //       .signInWithCredential(facebookAuthCredential);
  //   //   User? user = authResult.user;
  //   //   if (authResult.user != null) {
  //   //     await isUserExist(user!.email).then((value) async {
  //   //       if (value != 'Facebook' && value != '') {
  //   //         await FirebaseAuth.instance.signOut();
  //   //         await FacebookAuth.instance.logOut();
  //   //         return showAlertDialogOneButton(
  //   //             context,
  //   //             "L'utilisateur existe déjà",
  //   //             "Il existe déjà un compte avec cet e-mail, veuillez essayer de vous connecter avec $value",
  //   //             "Ok");
  //   //       } else {
  //   //         await getUserStatus(user!.uid).then((value) async {
  //   //           if (!value) {
  //   //             UserBase userBase = UserBase(
  //   //                 customer_uid: user.uid,
  //   //                 customer_full_name: user.displayName!,
  //   //                 customer_email: user.email!,
  //   //                 customer_phone_number: user.phoneNumber ?? '-',
  //   //                 customer_picture: user.photoURL!,
  //   //                 customer_date_naissance: '',
  //   //                 customer_sexe: '',
  //   //                 customer_auth_type: 'Facebook',
  //   //                 is_activated_account: false,
  //   //                 customer_cancelled_delivery: 0,
  //   //                 customer_succeded_delivery: 0,
  //   //                 customer_planned_delivery: 0,
  //   //                 customer_cancelled_trip: 0,
  //   //                 customer_succeded_trip: 0,
  //   //                 customer_planned_trip: 0,
  //   //                 customer_used_cities: [],
  //   //                 customer_note: 0,
  //   //                 customer_last_order_state: false,
  //   //                 customer_last_login_date:
  //   //                     DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                         .format(DateTime.now()),
  //   //                 customer_registration_date:
  //   //                     DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                         .format(DateTime.now()),
  //   //                 is_deleted_account: false,
  //   //                 is_verified_account: false,
  //   //                 customer_city: '',
  //   //                 customer_longitude: 0,
  //   //                 customer_latitude: 0,
  //   //                 customer_total_orders: 0);
  //   //             await SessionManager().set(
  //   //               'tmpUser',
  //   //               TmpUser(
  //   //                 phoneNo: '',
  //   //                 password: '',
  //   //                 email: user.email!,
  //   //                 is_exist: false,
  //   //                 type_auth: "Facebook",
  //   //               ),
  //   //             );
  //   //             GetStorage().write('isLoggedIn', true);
  //   //             await SessionManager().set('currentUser', userBase);
  //   //             await createUser(userBase).then(
  //   //               (value) async {
  //   //                 updateFcm(userBase);
  //   //                 goToOff(CompleteProfile());
  //   //               },
  //   //             );
  //   //           } else {
  //   //             await  getUserFix(user!.email, "Google").then((value) async {
  //   //               value.customer_last_login_date =
  //   //                   DateFormat("dd-MM-yyyy HH:mm", "Fr_fr")
  //   //                       .format(DateTime.now());
  //   //               await SessionManager().set(
  //   //                 'tmpUser',
  //   //                 TmpUser(
  //   //                   phoneNo: '',
  //   //                   password: '',
  //   //                   email: user.email!,
  //   //                   is_exist: true,
  //   //                   type_auth: "Facebook",
  //   //                 ),
  //   //               );
  //   //               UserBase userBase = value;
  //   //               await completeUser(userBase);
  //   //               await GetStorage().write('isLoggedIn', true);
  //   //               await SessionManager().set('currentUser', userBase);
  //   //               updateFcm(userBase);
  //   //               goToOff(const HomePage());
  //   //               Get.offAll(() => const HomePage(),
  //   //                   transition: Transition.rightToLeft);
  //   //             });
  //   //           }
  //   //         });
  //   //       }
  //   //     });
  //   //     loading.toggle();
  //   //   } else {
  //   //     loading.toggle();
  //   //   }
  //   // } catch (e) {
  //   //   loading.toggle();
  //   //   return showAlertDialogOneButton(context, "Problème avec Facebook",
  //   //       "Il n'y avait pas de compte facebook dans ce telephone", "Ok");
  //   // }
  // }
  //=============================================================================================
}
