// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:motopickupdriver/controllers/completeYourProfile/adding_photo_moto.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

import '../../utils/functions.dart';

class AddingPhotoMoto extends StatelessWidget {
  AddingPhotoMoto({Key? key}) : super(key: key);
  var controller = Get.put(AddingPhotoMotoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<AddingPhotoMotoController>(
        init: AddingPhotoMotoController(),
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
              // leading: InkWell(
              //   onTap: () => Get.back(),
              //   child: Icon(
              //     Boxicons.bx_arrow_back,
              //     color: primary,
              //     size: 30.h,
              //   ),
              // ),
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
                      'Ajouter une photo de moto',
                      style: primaryHeadlineTextStyle,
                    ),
                  ),
                  40.verticalSpace,
                  Center(
                    child: Container(
                      height: 250.h,
                      width: 250.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.file == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Boxicons.bxs_cloud_upload,
                                  color: light,
                                  size: 85.sp,
                                ),
                                5.verticalSpace,
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Text(
                                    'Téléchargez une photo récente de votre moto',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: light,
                                        fontFamily: 'LatoBold',
                                        fontSize: 14.sp),
                                  ),
                                )
                              ],
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
                      controller.selectImage();
                    },
                  ),
                  120.verticalSpace,
                  PrimaryButton(
                    text: 'Continuer',
                    function: () async {
                      controller.uploadImage(context);
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
