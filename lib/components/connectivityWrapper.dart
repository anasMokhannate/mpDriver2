// ignore_for_file: file_names

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

connectivityWrapper(Widget child) {
  return Material(
    child: ConnectivityWidgetWrapper(
      alignment: Alignment.center,
      stacked: false,
      offlineWidget: Column(
        children: [
          80.verticalSpace,
          Image.asset(
            'assets/images/logoMoto_colored.png',
            height: 50.h,
          ),
          80.verticalSpace,
          Image.asset(
            'assets/images/no_connection.png',
            height: 260.h,
          ),
          10.verticalSpace,
          Text(
            'Whoops',
            style: TextStyle(
                fontFamily: 'LatoBold', fontSize: 36.sp, color: primary),
          ),
          20.verticalSpace,
          Text(
            "S'il vous plait, vérifiez votre connexion internet!",
            style: TextStyle(
                fontFamily: 'LatoSemiBold', fontSize: 14.sp, color: primary),
          ),
          80.verticalSpace,
        ],
      ),
      disableInteraction: true,
      child: child,
    ),
  );
}
