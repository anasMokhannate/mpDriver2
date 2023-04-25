// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

import 'package:url_launcher/url_launcher_string.dart';

Future<bool> willPopScoop(context) {
  bool exit2 = false;

  // set up the button
  Widget okButton = InkWell(
    onTap: () {
      exit2 = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        exit(0);
      });
    },
    child: Text(
      'Oui',
      style: linkTextStyle,
    ),
  );
  Widget cancelButton = InkWell(
    onTap: () {
      Navigator.pop(context, false);
    },
    child: Text(
      'Non',
      style: linkTextStyle,
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Quittez l'application",
      style: TextStyle(
        fontSize: 16.sp,
        color: primary,
        fontFamily: 'LatoSemiBold',
      ),
    ),
    content: Text(
      "Voulez-vous quitter l'application ?",
      style: bodyTextStyle,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20.w, bottom: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [cancelButton, 40.horizontalSpace, okButton],
        ),
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return Future.value(true);
}

showAlertDialogOneButton(BuildContext context, title, text, btnText) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(
      btnText,
      style: alertDialogLink,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: alertDialogTitle,
    ),
    content: Text(
      text,
      style: alertDialogText,
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

orderCancel(BuildContext context, title, text, btnText, btnFunction) {
  // set up the button
  Widget okButton = TextButton(
    onPressed: btnFunction,
    child: Text(
      btnText,
      style: alertDialogLink,
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: alertDialogTitle,
    ),
    content: Text(
      text,
      style: alertDialogText,
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogTwoButton(
    BuildContext context, title, text, btnOne, btnTwo, function) {
  // set up the button
  Widget okButton = TextButton(
    onPressed: function,
    child: Text(
      btnOne,
      style: alertDialogLink,
    ),
  );

  // set up the button
  Widget cancel = TextButton(
    child: Text(
      btnTwo,
      style: alertDialogLink,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: alertDialogTitle,
    ),
    content: Text(
      text,
      style: alertDialogText,
    ),
    actions: [cancel, okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

aucunDriver(BuildContext context, annulerFunction) {
  // set up the button
  Widget okButton = TextButton(
    onPressed: () {},
    child: Text(
      'Réessayer ',
      style: alertDialogLink,
    ),
  );

  // set up the button
  Widget cancel = TextButton(
    onPressed: annulerFunction,
    child: Text(
      'Annuler',
      style: TextStyle(
        fontSize: 15.sp,
        color: Colors.red,
        fontFamily: "LatoSemiBold",
      ),
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Aucun Chauffeur",
      style: alertDialogTitle,
    ),
    content: Text(
      "la commande prend beaucoup de temps, Il n’y a pas actuellement de Motopickup à proximité de votre point de départ",
      style: alertDialogText,
    ),
    actions: [cancel, okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

becameDriver(BuildContext context) {
  // set up the button
  Widget okButton = PrimaryButton(
      text: 'Rejoindre',
      function: () {
        launchUrlString(
          'https://motopickup.com/accueil#rejoignez',
        );
      });
  Widget cancelButton = OutlineButton(
      text: 'Annuler',
      function: () {
        Navigator.pop(context, false);
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
        child: Text(
      'Devenir chauffeur Motopick-up ?',
      style: primaryHeadlineTextStyle,
    )),
    content: RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text:
            "Pour rejoindre nos motards, c'est très simple, rendez-vous sur: ",
        style: TextStyle(
          fontSize: 14.sp,
          color: dark,
          height: 1.8,
          fontFamily: "LatoSemiBold",
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'https://motopickup.com/accueil#rejoignez',
            style: TextStyle(
              fontSize: 14.sp,
              color: primary,
              height: 1.8,
              fontFamily: "LatoSemiBold",
            ),
          ),
        ],
      ),
    ),
    actions: [
      Center(child: okButton),
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

paiment(BuildContext context, functionYes) {
  // set up the button
  Widget okButton = InkWell(
    onTap: functionYes,
    child: Container(
      height: 40.h,
      width: 127.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Oui',
        style: TextStyle(
            fontFamily: 'LatoBold', fontSize: 14.sp, color: Colors.white),
      ),
    ),
  );
  Widget cancelButton = InkWell(
    onTap: functionYes,
    child: Container(
      height: 40.h,
      width: 127.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Non',
        style: TextStyle(
            fontFamily: 'LatoBold', fontSize: 14.sp, color: Colors.white),
      ),
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Icon(
        Boxicons.bx_info_circle,
        color: primary,
        size: 80.h,
      ),
    ),
    content: Text(
      'Avez-vous reçu votre paiment avec succès ?',
      style: bodyTextStyle,
    ),
    actions: [
      Row(
        children: [okButton, const Spacer(), cancelButton],
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



/*void showAchievementView(BuildContext context, title, text) {
  AchievementView(context,
      title: title,
      subTitle: text,
      //onTab: _onTabAchievement,
      icon: const Icon(
        Boxicons.bx_like,
        color: Colors.white,
      ),
      //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
      //borderRadius: 5.0,
      color: primary,
      textStyleTitle: drawerTextStyle,
      textStyleSubTitle: drawerTextStyle,
      //alignment: Alignment.topCenter,
      duration: const Duration(seconds: 4),
      isCircle: true, listener: (status) {
    print(status);
    //AchievementState.opening
    //AchievementState.open
    //AchievementState.closing
    //AchievementState.closed
  }).show();
}
 */