// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/controllers/orders/details_order.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

class DetailsOrder extends StatelessWidget {
  DetailsOrder({Key? key}) : super(key: key);
  var controller = Get.put(DetailsOrderController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        body: SingleChildScrollView(
          child: controller.orderType == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              height: 56.h,
                              width: 56.h,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Boxicons.bx_package,
                                color: primary,
                                size: 30.h,
                              ),
                            ),
                            15.horizontalSpace,
                            SizedBox(
                              height: 56.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Text(
                                    'ID202202011017888',
                                    style: bodyTextStyle,
                                  ),
                                  10.verticalSpace,
                                  Text('Colis livré', style: bodyTextStyle),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Boxicons.bx_star,
                              color: Colors.yellow[600],
                              size: 32.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Boxicons.bxs_circle,
                                        size: 10.h,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        height: 25.h,
                                        width: 2.w,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                      ),
                                      Icon(
                                        Boxicons.bxs_circle,
                                        size: 10.h,
                                      ),
                                    ],
                                  ),
                                  10.horizontalSpace,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'De : El Mechouar Stinia, Meknes',
                                        style: bodyTextStyle,
                                      ),
                                      10.verticalSpace,
                                      Text(
                                        'À : Bd Essaadiyine, Meknes',
                                        style: bodyTextStyle,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              20.verticalSpace,
                              Row(
                                children: [
                                  const Icon(Boxicons.bx_time),
                                  Text(
                                    'Date',
                                    style: bodyTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '22-07-2022 17:30',
                                    style: bodyTextStyle,
                                  ),
                                ],
                              ),
                              20.verticalSpace,
                              Row(
                                children: [
                                  const Icon(Boxicons.bx_money),
                                  Text(
                                    'Prix',
                                    style: bodyTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '15 DHS',
                                    style: bodyTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.w),
                      child: Container(
                        height: 120.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: border, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 56.h,
                                    width: 56.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1601290243463-0b18961c3628?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  15.horizontalSpace,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mohamed Saidi',
                                        style: bodyTextStyle,
                                      ),
                                      5.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Boxicons.bxs_star,
                                              color: primary, size: 20.h),
                                          Icon(Boxicons.bxs_star,
                                              color: primary, size: 20.h),
                                          Icon(Boxicons.bxs_star,
                                              color: primary, size: 20.h),
                                          Icon(Boxicons.bx_star,
                                              color: primary, size: 20.h),
                                          Icon(Boxicons.bx_star,
                                              color: primary, size: 20.h)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    'Go Comfort',
                                    style: linkTextStyle,
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    Boxicons.bxs_circle,
                                    color: dark,
                                    size: 10.h,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    'Yamaha T-Max 560',
                                    style: bodyTextStyle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Center(
                      child: Container(
                        height: 55.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(360),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Signaler un incident',
                          style: lightButtonTextStyle,
                        ),
                      ),
                    ),
                  ],
                )
              : controller.orderType == 2
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Container(
                                  height: 56.h,
                                  width: 56.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD73B29)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Boxicons.bx_package,
                                    color: const Color(0xFFD73B29),
                                    size: 30.h,
                                  ),
                                ),
                                15.horizontalSpace,
                                SizedBox(
                                  height: 56.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Spacer(),
                                      Text(
                                        'ID202202011017888',
                                        style: bodyTextStyle,
                                      ),
                                      10.verticalSpace,
                                      Text('Colis Annulé',
                                          style: bodyTextStyle),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: border, width: 1.2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            Boxicons.bxs_circle,
                                            size: 10.h,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            height: 25.h,
                                            width: 2.w,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(360)),
                                          ),
                                          Icon(
                                            Boxicons.bxs_circle,
                                            size: 10.h,
                                          ),
                                        ],
                                      ),
                                      10.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'De : El Mechouar Stinia, Meknes',
                                            style: bodyTextStyle,
                                          ),
                                          10.verticalSpace,
                                          Text(
                                            'À : Bd Essaadiyine, Meknes',
                                            style: bodyTextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    children: [
                                      const Icon(Boxicons.bx_time),
                                      Text(
                                        'Date',
                                        style: bodyTextStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '22-07-2022 17:30',
                                        style: bodyTextStyle,
                                      ),
                                    ],
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    children: [
                                      const Icon(Boxicons.bx_money),
                                      Text(
                                        'Prix',
                                        style: bodyTextStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '15 DHS',
                                        style: bodyTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        5.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.w),
                          child: Container(
                            height: 120.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: border, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 56.h,
                                        width: 56.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1601290243463-0b18961c3628?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      15.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mohamed Saidi',
                                            style: bodyTextStyle,
                                          ),
                                          5.verticalSpace,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bx_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bx_star,
                                                  color: primary, size: 20.h)
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        'Go Comfort',
                                        style: linkTextStyle,
                                      ),
                                      10.horizontalSpace,
                                      Icon(
                                        Boxicons.bxs_circle,
                                        color: dark,
                                        size: 10.h,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        'Yamaha T-Max 560',
                                        style: bodyTextStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Center(
                          child: Container(
                            height: 55.h,
                            width: 220.w,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(360),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Signaler un incident',
                              style: lightButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Container(
                                  height: 56.h,
                                  width: 56.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA39874)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Boxicons.bx_package,
                                    color: const Color(0xFFA39874),
                                    size: 30.h,
                                  ),
                                ),
                                15.horizontalSpace,
                                SizedBox(
                                  height: 56.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Spacer(),
                                      Text(
                                        'ID202202011017888',
                                        style: bodyTextStyle,
                                      ),
                                      10.verticalSpace,
                                      Text('Il reste 36 min',
                                          style: bodyTextStyle),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: border, width: 1.2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            Boxicons.bxs_circle,
                                            size: 10.h,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            height: 25.h,
                                            width: 2.w,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(360)),
                                          ),
                                          Icon(
                                            Boxicons.bxs_circle,
                                            size: 10.h,
                                          ),
                                        ],
                                      ),
                                      10.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'De : El Mechouar Stinia, Meknes',
                                            style: bodyTextStyle,
                                          ),
                                          10.verticalSpace,
                                          Text(
                                            'À : Bd Essaadiyine, Meknes',
                                            style: bodyTextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    children: [
                                      const Icon(Boxicons.bx_time),
                                      Text(
                                        'Date',
                                        style: bodyTextStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '22-07-2022 17:30',
                                        style: bodyTextStyle,
                                      ),
                                    ],
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    children: [
                                      const Icon(Boxicons.bx_money),
                                      Text(
                                        'Prix',
                                        style: bodyTextStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '15 DHS',
                                        style: bodyTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        5.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.w),
                          child: Container(
                            height: 120.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: border, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 56.h,
                                        width: 56.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1601290243463-0b18961c3628?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      15.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mohamed Saidi',
                                            style: bodyTextStyle,
                                          ),
                                          5.verticalSpace,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bxs_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bx_star,
                                                  color: primary, size: 20.h),
                                              Icon(Boxicons.bx_star,
                                                  color: primary, size: 20.h)
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        'Go Comfort',
                                        style: linkTextStyle,
                                      ),
                                      10.horizontalSpace,
                                      Icon(
                                        Boxicons.bxs_circle,
                                        color: dark,
                                        size: 10.h,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        'Yamaha T-Max 560',
                                        style: bodyTextStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Center(
                          child: Container(
                            height: 55.h,
                            width: 220.w,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(360),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Annuler',
                              style: lightButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
