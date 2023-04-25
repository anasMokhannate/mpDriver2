import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/views/home_page.dart';

class UsingConditionScreen extends StatelessWidget {
  const UsingConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () =>
              Get.offAll(() => HomePage(), transition: Transition.rightToLeft),
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
      body: Container(
        width: 375.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              Center(
                child: Text(
                  "Conditions d'utilisation",
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
                ),
              ),
              20.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Avant la course:",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                  10.verticalSpace,
                  Text(
                    "- Les conducteurs doivent vérifier régulièrement la maintenance de la motocyclettes.\n- Garder la motocyclettes propre et en bon état.\n- Préparer d'avance de la monnaie.\n- N'acceptez dans votre trajet que les passagers prévus.",
                    style: TextStyle(fontSize: 14.sp, height: 1.35.h),
                  ),
                  15.verticalSpace,
                  Text(
                    "Après la course:",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                  10.verticalSpace,
                  Text(
                    "Si jamais le passager a oublié des effets personnels contacter le service d'assistance.",
                    style: TextStyle(fontSize: 14.sp, height: 1.35.h),
                  ),
                  15.verticalSpace,
                  Text(
                    "Lorsque vous acceptez une commande de course: ",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                  10.verticalSpace,
                  Text(
                    "- Eviter l'acceptation des commandes dans les zones noires. Et utiliser le GPS pour gagner du temps.\n- Acceptez les commandes qui vous conviennent. Et faites attention aux commentaires des passagers.\n- Informer le passager de votre temps d'arriver et si vous êtes en retard vous devez prévenir le passager.\n- Marquez la fin du trajet lorsque vous atteignez l'adresse.",
                    style: TextStyle(fontSize: 14.sp, height: 1.35.h),
                  ),
                  15.verticalSpace,
                  Text(
                    "Pendant le trajet :",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                  10.verticalSpace,
                  Text(
                    "- Le chauffeur doit rester à l'écoute du passager .Au cas le chauffeur veut changer le trajet il doit prévenir le passager et prend son accord.\n- Les choses qui peuvent augmenter la priorité des chauffeurs.\n- La politesse\n- La bonne humeur\n- Le respect du code de la route\n- La propreté du chauffeur\n- Il est interdit aux chauffeurs de fumer pendant la course ou faire des arrêts personnels.",
                    style: TextStyle(fontSize: 14.sp, height: 1.35.h),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
