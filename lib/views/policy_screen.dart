import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/policies_list.dart';

import 'home_page.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () =>  Get.offAll(() => const HomePage(), transition: Transition.leftToRight),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Center(
                child: Text(
                  "La politique de confidentialité",
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
                ),
              ),
              20.verticalSpace,
              Text(
                "Cette politique de confidentialité s'applique à nos Services, quel que soit l'endroit où ils sont fournis, et nous nous conformerons aux lois locales pour toutes les règles et procédures décrites dans cette politique. En cas d'incompatibilité entre les dispositions de la présente politique et celles du droit local, nous nous engageons à respecter le droit local en ce qui concerne cette incompatibilité.\nLe service MOTO PICKUP AFRICA est fourni et contrôlé par la personne morale définie dans les Conditions d'utilisation applicables au Maroc.\nCette politique s'applique à tous les utilisateurs du service MOTO PICKUP AFRICA, y compris les utilisateurs de notre site web, Moto Pick-up (motopickup.com) / (ci-après dénommé « Site web »), de toute application mobile Moto Pick-up driver destinée au Chauffeurs et Moto Pick-up pour les clients (ci-après dénommées « Applications »), ainsi qu'à tous services que nous fournissons par le biais du Site web ou des Applications, et dans le cas de contacts par téléphone, par courriel, par écrit par correspondance, par les réseaux sociaux, dans le cadre de visites personnelles, ou par tout autre moyen de communication (ci-après collectivement dénommés « Services »). Cette politique ne s'applique pas à la manière dont nous traitons les informations que nous collectons concernant nos employés ou nos partenaires commerciaux, y compris sur nos partenaires professionnels, nos fournisseurs et nos sous-traitants, mais elle s'applique cependant à nos Chauffeurs. \nDans le cadre de cette politique, les personnes qui utilisent nos services sont dénommées « Utilisateurs ». Les Utilisateurs qui demandent ou bénéficient d'un transport sont dénommés « Passagers », alors que ceux qui assurent le transport des Passagers sont dénommés « Chauffeurs ». Les termes en majuscules utilisés qui ne sont pas définis dans la présente politique ont la signification qui leur est donnée dans les Conditions d'utilisation. En acceptant les Conditions d'utilisation, vous acceptez le traitement de vos données suivant les modalités qui sont décrites dans la présente politique.",
                style: TextStyle(height: 1.35.h, fontSize: 14.sp),
              ),
              15.verticalSpace,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        policies[index].title!,
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2),
                      ),
                      10.verticalSpace,
                      if (policies[index].body != null)
                        Text(
                          policies[index].body!,
                          style: TextStyle(fontSize: 14.sp, height: 1.35.h),
                        ),
                      if (policies[index].infos != null)
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, ide) => Text(
                                  "- ${policies[index].infos![ide]}",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      height: 1.35.h,
                                      fontWeight: FontWeight.w600),
                                ),
                            separatorBuilder: (context, ide) => 7.verticalSpace,
                            itemCount: policies[index].infos!.length)
                    ],
                  ),
                ),
                itemCount: policies.length,
                separatorBuilder: (BuildContext context, int index) =>
                    10.verticalSpace,
              ),
              10.verticalSpace,
              Text(
                "Modification",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2),
              ),
              10.verticalSpace,
              Text(
                "Nous pouvons mettre à jour cette politique de temps en temps pour tenir compte des changements dans la législation ou dans la façon dont nos services sont fournis. Nous vous informerons des mises à jour de cette Politique de confidentialité en modifiant la « Date de dernière mise à jour » en haut de cette page, ainsi qu'en publiant la nouvelle version de la Politique de confidentialité et en fournissant toute autre notification prévue par la législation en vigueur. Nous vous encourageons à consulter cette page de temps en temps pour vous assurer que vous êtes au courant de nos politiques et procédures de confidentialité.\nEn utilisant le service MOTO PICKUP AFRICA, vous acceptez les dernières dispositions applicables de cette politique.",
                style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.35.h,),
              ),
              15.verticalSpace,
              Text(
                "Les questions, commentaires et requêtes relatifs à cette politique doivent être adressés à E-mail:",
                style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.35.h,),
              ),
              10.verticalSpace,
              Text(
                "contact.motopickup@gmail.com",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
              20.verticalSpace
            ],
          ),
        ),
      ),
    );
  }
}
