// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/controllers/my_bikes.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/models/moto.dart';
import 'package:motopickupdriver/utils/typography.dart';

class MyBikes extends StatelessWidget {
  MyBikes({Key? key}) : super(key: key);
  var controller = Get.put(MyBikesController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MyBikesController>(
        init: MyBikesController(),
        builder: (value) => Scaffold(
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
          body: controller.isTrue.value
              ? Column(
                  children: [
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Mes Motos',
                        style: primaryHeadlineTextStyle,
                      ),
                    ),
                    20.verticalSpace,
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.listMoto!.length,
                        itemBuilder: (index, i) {
                          Moto moto = Moto.fromJson(controller.listMoto![i]);
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              height: 120.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: primary),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 80.w,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey,
                                      ),
                                      child: Image.network(
                                        moto.motocycle_photo,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Marque:${moto.motocycle_brand}",
                                          style: bodyTextStyle,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Couleur:${moto.motocycle_color}",
                                          style: bodyTextStyle,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Modele:${moto.motocycle_model}",
                                          style: bodyTextStyle,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Immatriculation:${moto.motocycle_imm}",
                                          style: bodyTextStyle,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Text('Here'),
        ),
      ),
    );
  }
}
