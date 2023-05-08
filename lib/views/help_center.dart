// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/help_center.dart';
import 'package:motopickupdriver/utils/alert_dialog.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatelessWidget {
  HelpCenter({Key? key}) : super(key: key);
  var controller = Get.put(HelpCenterController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: false,
        color: dark,
        progressIndicator: const CircularProgressIndicator(
          color: dark,
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: Scaffold(
          backgroundColor: scaffold,
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Get.back(),
              child: Icon(
                Boxicons.bx_arrow_back,
                color: primary,
                size: 30.h,
              ),
            ),
            toolbarHeight: 80.h,
            title: Image.asset(
              'assets/images/logoMoto_colored.png',
              height: 50.h,
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Center(
                child: Image.asset(
                  'assets/images/support.webp',
                  height: 95.h,
                ),
              ),
              20.verticalSpace,
              Center(
                child: Text(
                  'Besoin de notre aide ?',
                  style: primaryHeadlineTextStyle,
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Notre équipe est à votre disposition pour répondre à toutes vos questions et vous assister en cas de problème avec nos services.',
                  textAlign: TextAlign.center,
                  style: bodyTextStyle,
                ),
              ),
              20.verticalSpace,
              SocialButton(
                color: primary,
                text: 'contact@motopickup.com',
                icon: Boxicons.bx_envelope,
                function: ()async {
                    final Uri params = Uri(
  scheme: 'mailto',
  path: 'contact@motopickup.com',
  query: 'subject=App Feedback&body=Bonjour', //add subject and body here
);

var url = params.toString();
if (await canLaunch(url)) {
  await launch(url);
} else {
  throw 'Could not launch $url';
}

                },
              ),
              10.verticalSpace,
              SocialButton(
                color: primary,
                text: '(+212) 637 676 298',
                icon: Boxicons.bx_phone,
                function: () async {
                  await FlutterPhoneDirectCaller.callNumber('212637676298');
                },
              ),
              10.verticalSpace,
              SocialButton(
                color: primary,
                text: 'Partager ma position',
                icon: Boxicons.bx_map_pin,
                function: () async {
                  controller.shareMyLocation().then((value) {
                    showAlertDialogOneButton(
                        context,
                        '',
                        "Votre position a été partagée avec le centre d'aide.",
                        'Ok');
                  });
                },
              ),
              10.verticalSpace,
              SocialButton(
                color: Colors.red,
                text: 'Appeler la police',
                icon: Boxicons.bx_error,
                function: () async {
                  await FlutterPhoneDirectCaller.callNumber('19');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}