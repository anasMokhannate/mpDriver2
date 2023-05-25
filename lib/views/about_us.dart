import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

class AboutUspage extends StatelessWidget {
  const AboutUspage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'MOTO PICK UP',
                  style: primaryHeadlineTextStyle,
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'MOTO PICK UP est un service de transport en moto à vocation sociale, environnementale et économique qui donne naissance à un nouveau mode de mobilité qui résout trois problèmes majeurs qui font malheureusement notre quotidien:',
                  style: bodyTextStyle,
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Boxicons.bx_check,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Embouteillage',
                          style: bodyTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Boxicons.bx_check,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Zone Male Desservie En Transport Commun',
                          style: bodyTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Boxicons.bx_check,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Pollution',
                          style: bodyTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Chez Moto pick UP nous œuvrons chaque pour faciliter vos déplacement urgents ou quotidien, que ce soit pour arriver à votre lieu de travail même dans les zones industrielles les plus lointaines, arriver à temps à votre RDV même dans les créneaux d’embouteillage, vous épargnez les longues attentes des transports ou remédier de prendre des moyens de transports non conformes aux exigences de sécurité.\n\nAvec MOTO PICK UP vous faites le choix intelligeant de combiner disponibilité, sécurité, rapidité et petits prix.',
                  style: bodyTextStyle,
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Vos déplacements se font désormais en trois étapes',
                  style: bodyTextStyle,
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          size: 15.h,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            'Commandez votre moto en ligne sur l’application MOTO PICK UP',
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          size: 15.h,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            'Choisissez votre chauffeur',
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          size: 15.h,
                          color: primary,
                        ),
                        10.horizontalSpace,
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            'Votre chauffeur vient vous récupérer',
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
