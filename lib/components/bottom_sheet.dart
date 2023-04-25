import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motopickupdriver/utils/buttons.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

modalBottom(context, isCoursier, isDriver, action, turnCoursier, turnDriver) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Wrap(
            children: [
              Container(
                height: 20.h,
                color: Colors.white,
              ),
              Center(
                child: Container(
                  width: 225.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: dark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(360),
                  ),
                ),
              ),
              Container(
                height: 20.h,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Je veux utiliser cette application en tant que:',
                  style: bodyTextStyle,
                ),
              ),
              Container(
                height: 20.h,
                color: Colors.white,
              ),
              InkWell(
                onTap: turnCoursier,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        15.horizontalSpace,
                        Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary,
                            ),
                          ),
                          child: Icon(
                            Boxicons.bx_check,
                            color: isCoursier ? primary : Colors.transparent,
                          ),
                        ),
                        15.horizontalSpace,
                        Text(
                          'Coursier',
                          style: alertDialogTitle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 20.h,
                color: Colors.white,
              ),
              InkWell(
                onTap: turnDriver,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        15.horizontalSpace,
                        Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary,
                            ),
                          ),
                          child: Icon(
                            Boxicons.bx_check,
                            color: isDriver ? primary : Colors.transparent,
                          ),
                        ),
                        15.horizontalSpace,
                        Text(
                          'Chauffeur',
                          style: alertDialogTitle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 20.h,
                color: Colors.white,
              ),
              PrimaryButton(
                text: 'Terminer',
                function: () async {},
              ),
              Container(
                height: 40.h,
                color: Colors.white,
              ),
            ],
          );
        },
      );
    },
  );
}
