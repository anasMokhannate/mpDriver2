// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/inputs.dart';
import 'package:motopickupdriver/controllers/completeYourProfile/complete_profile.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

import '../../utils/functions.dart';

class CompleteProfile extends StatelessWidget {
  CompleteProfile({Key? key}) : super(key: key);
  var controller = Get.put(CompleteProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.h,
              title: Image.asset(
                'assets/images/logoMoto_colored.png',
                height: 50.h,
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Boxicons.bx_log_out,
                    color: primary,
                    size: 30.h,
                  ),
                  onPressed: () async {
                    logout(context);
                  },
                )
              ],
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
                        40.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Dites-nous plus sur vous!',
                            style: primaryHeadlineTextStyle,
                          ),
                        ),
                        40.verticalSpace,
                        InputTextField(
                          hintText: 'Entrez votre nom complet',
                          type: TextInputType.text,
                          controller: controller.fullname,
                          icon: Boxicons.bxs_user,
                        ),
                        5.verticalSpace,
                        InputTextField(
                          hintText: 'Entrez votre Email',
                          type: TextInputType.emailAddress,
                          controller: controller.email,
                          icon: Boxicons.bxs_envelope,
                          enable: false,
                        ),
                        5.verticalSpace,
                        GetBuilder<CompleteProfileController>(
                          init: CompleteProfileController(),
                          builder: (value) => InputDatePicker(
                            dateText: controller.birthday,
                            icon: Boxicons.bxs_calendar,
                            function: () => DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                controller.birthday = DateFormat('dd-MM-yyyy')
                                    .format(date)
                                    .toString();
                                controller.update();
                              },
                              currentTime: DateTime.now()
                                  .subtract(const Duration(days: 6570)),
                              maxTime: DateTime.now()
                                  .subtract(const Duration(days: 6570)),
                              minTime: DateTime.now()
                                  .subtract(const Duration(days: 36500)),
                              locale: context.locale.toString() == 'fr'
                                  ? LocaleType.fr
                                  : LocaleType.ar,
                            ),
                          ),
                        ),
                        17.verticalSpace,
                        GetBuilder<CompleteProfileController>(
                          init: CompleteProfileController(),
                          builder: (value) => DropDownMenu(
                            items: controller.dropdownSexeItems,
                            listItem: controller.sexe,
                            function: (value) {
                              controller.dropDownMenuChange(value);
                              controller.update();
                            },
                          ),
                        ),
                        17.verticalSpace,
                        GetBuilder<CompleteProfileController>(
                          init: CompleteProfileController(),
                          builder: (value) => CityPicker(
                            initialData: controller.initialData,
                            selected: controller.selected,
                            selectedList: controller.selectedList,
                            function: (data) {
                              controller.cityPickerChange(data);
                              controller.update();
                            },
                          ),
                        ),
                        15.verticalSpace,
                        InputTextField(
                          hintText:
                              'Numéro de carte d\'identification national',
                          type: TextInputType.text,
                          controller: controller.cni,
                          icon: Boxicons.bxs_key,
                        ),
                        20.verticalSpace,
                        PrimaryButton(
                          text: 'Continuer',
                          function: () {
                            controller.submit(context);
                            controller.update();
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
