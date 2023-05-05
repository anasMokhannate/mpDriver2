import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:motopickupdriver/views/onboarding/using_condition_screen.dart';

// * Function For Sign out
Future<Future> logout(context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Confirmation",
        style: linkTextStyle,
      ).tr(),
      content: Text(
        "Êtes-vous certain de vouloir vous déconnecter?",
        style: bodyTextStyle,
      ).tr(),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Non",
            style: linkTextStyle,
          ).tr(),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(
            "Oui",
            style: linkTextStyle,
          ).tr(),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            // String fcm = await SessionManager().get('user_fcm')??'';
            await GoogleSignIn(scopes: ['profile', 'email']).signOut();
            await SessionManager().remove("currentUser");
            await SessionManager().get("hasAccepted").then((value){
              value = false;
               Get.offAll(() => const UsingConditionScreen());
            });
            // await SessionManager().destroy();
            // await SessionManager().set('user_fcm', fcm);
          },
        )
      ],
    ),
  );
}

// * Function For Delete account
Future<Future> deleteAccount(context, function, controller) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Supprimer mon compte",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.red,
          height: 1.2,
          fontFamily: "LatoRegular",
        ),
      ).tr(),
      content: Container(
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 10,
            style: inputTextStyle, //or null
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: "Votre avis nous intéresse",
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.circleQuestion,
                    color: dark,
                  ),
                  10.horizontalSpace,
                  Text(
                    "Support",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: dark,
                      height: 1.2,
                      fontFamily: "LatoRegular",
                    ),
                  ).tr(),
                ],
              ),
              onPressed: () {
                Navigator.pop(context, false);
                //Get.to(HelpCenter(), transition: Transition.rightToLeft);
              },
            ),
            const Spacer(),
            TextButton(
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                  height: 1.2,
                  fontFamily: "LatoRegular",
                ),
              ).tr(),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              onPressed: function,
              child: Text(
                "Confirmer",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  height: 1.2,
                  fontFamily: "LatoRegular",
                ),
              ).tr(),
            )
          ],
        )
      ],
    ),
  );
}

bool validateEmail(String email) {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
  return emailRegex.hasMatch(email);
}

bool validatePassword(String value) {
  RegExp regex = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*?[0-9]).{9,}$');
  if (value.isEmpty) {
    return false;
  } else {
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
}
