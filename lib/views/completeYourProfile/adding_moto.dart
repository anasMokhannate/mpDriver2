// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/inputs.dart';
import 'package:motopickupdriver/controllers/completeYourProfile/adding_moto.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

class AddingMoto extends StatelessWidget {
  AddingMoto({Key? key}) : super(key: key);
  var controller = Get.put(AddingMotoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<AddingMotoController>(
        init: AddingMotoController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: Scaffold(
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
            body: !controller.isTrue.value
                ? Center(
                    child: SizedBox(
                      width: 225.w,
                      child: const LoadingIndicator(
                          indicatorType: Indicator.ballScaleMultiple,
                          colors: [primary],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Ajouter votre motocyclette',
                            style: primaryHeadlineTextStyle,
                          ),
                        ),
                        40.verticalSpace,
                        InputTextField(
                          hintText: 'Marque',
                          type: TextInputType.text,
                          controller: controller.marque,
                          icon: Boxicons.bxs_certification,
                        ),
                        10.verticalSpace,
                        InputTextField(
                          hintText: 'Modèle',
                          type: TextInputType.number,
                          controller: controller.modele,
                          icon: Boxicons.bxs_calendar_alt,
                        ),
                        10.verticalSpace,
                        InputTextField(
                          hintText: 'Immatriculation',
                          type: TextInputType.text,
                          controller: controller.imma,
                          icon: Boxicons.bxl_markdown,
                        ),
                        10.verticalSpace,
                        InputTextField(
                          hintText: 'Couleur',
                          type: TextInputType.text,
                          controller: controller.color,
                          icon: Boxicons.bxs_color_fill,
                        ),
                        10.verticalSpace,
                        GetBuilder<AddingMotoController>(
                          init: AddingMotoController(),
                          builder: (value) => DropDownMenu(
                            items: controller.dropdowntypeItems,
                            listItem: controller.type,
                            function: (value) {
                              controller.dropDownMenuChange(value);
                              controller.update();
                            },
                          ),
                        ),
                        17.verticalSpace,
                        PrimaryButton(
                          text: 'Continuer',
                          function: () async {
                            controller.submit(context);
                          },
                        ),
                        40.verticalSpace,
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
