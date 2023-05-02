// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/components/connectivityWrapper.dart';
import 'package:motopickupdriver/controllers/profile/edit_image.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

class EditImage extends StatelessWidget {
  EditImage({Key? key}) : super(key: key);
  var controller = Get.put(EditImageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<EditImageController>(
        init: EditImageController(),
        builder: (value) => LoadingOverlay(
          isLoading: controller.loading.value,
          color: dark,
          progressIndicator: const CircularProgressIndicator(
            color: dark,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          child: connectivityWrapper(
            Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
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
                        'Choisissez votre photo de profil',
                        style: primaryHeadlineTextStyle,
                      ),
                    ),
                    40.verticalSpace,
                    Center(
                      child: Container(
                        height: 280.h,
                        width: 280.h,
                        decoration: BoxDecoration(
                          color: dark.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.file == null
                            ? Icon(
                                FontAwesomeIcons.cloudArrowUp,
                                color: dark.withOpacity(0.4),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    10.verticalSpace,
                    PrimaryOutlineButton(
                      text: 'Télécharger une nouvelle image',
                      function: () async {
                        await controller.selectImage();
                      },
                    ),
                    100.verticalSpace,
                    PrimaryButton(
                      text: 'Terminer',
                      function: () async {
                        await controller.uploadImage(context);
                      },
                    ),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
