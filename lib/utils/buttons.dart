// ignore_for_file: must_be_immutable, duplicate_ignore
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/typography.dart';

// ignore: must_be_immutable
class SocialButton extends StatefulWidget {
  Color color;
  String text;
  IconData icon;
  final VoidCallback function;

  SocialButton(
      {required this.color,
      required this.text,
      required this.icon,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          height: 65.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(360),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              40.horizontalSpace,
              Icon(
                widget.icon,
                color: Colors.white,
              ),
              20.horizontalSpace,
              Text(widget.text, style: lightButtonTextStyle).tr(),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneButton extends StatefulWidget {
  Color color;
  String text;
  final VoidCallback function;

  PhoneButton(
      {required this.color,
      required this.text,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<PhoneButton> createState() => _PhoneButtonState();
}

class _PhoneButtonState extends State<PhoneButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          height: 65.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(360),
          ),
          alignment: Alignment.center,
          child: Text(widget.text, style: darkButtonTextStyle).tr(),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  String text;
  final VoidCallback function;
  PrimaryButton({required this.text, required this.function, Key? key})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Center(
        child: Container(
          height: 65.h,
          width: 250.w,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(360),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
                fontFamily: 'LatoBold', fontSize: 14.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
  String text;
  final VoidCallback function;
  OutlineButton({required this.text, required this.function, Key? key})
      : super(key: key);

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Center(
        child: Container(
          height: 65.h,
          width: 250.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            //border: Border.all(color: primary, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
                fontFamily: 'LatoBold', fontSize: 14.sp, color: primary),
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatefulWidget {
  String text;
  IconData icon;
  final VoidCallback function;
  HomeButton(
      {required this.text,
      required this.function,
      required this.icon,
      Key? key})
      : super(key: key);

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Container(
            height: 65.h,
            width: 360.w,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(360),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                20.horizontalSpace,
                Icon(
                  widget.icon,
                  color: light,
                  size: 30.h,
                ),
                const Spacer(),
                Text(
                  widget.text,
                  style: TextStyle(
                      fontFamily: 'LatoBold',
                      fontSize: 14.sp,
                      color: Colors.white),
                ),
                const Spacer(),
                const Icon(
                  FontAwesomeIcons.arrowRight,
                  color: Colors.white,
                ),
                20.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SupportButton extends StatefulWidget {
  Color mode;
  SupportButton({required this.mode, Key? key}) : super(key: key);

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Get.to(() => HelpCenter(), transition: Transition.rightToLeft);
      },
      child: Container(
        height: 65.h,
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: Border.all(
            color: widget.mode,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            25.horizontalSpace,
            Icon(
              FontAwesomeIcons.circleQuestion,
              color: widget.mode,
              size: 25.h,
            ),
            25.horizontalSpace,
            Text(
              'Support',
              style: TextStyle(
                fontFamily: "LatoSemiBold",
                fontSize: 16.sp,
                color: widget.mode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryOutlineButton extends StatefulWidget {
  String text;
  final VoidCallback function;
  PrimaryOutlineButton({required this.text, required this.function, Key? key})
      : super(key: key);

  @override
  State<PrimaryOutlineButton> createState() => _PrimaryOutlineButtonState();
}

class _PrimaryOutlineButtonState extends State<PrimaryOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Center(
        child: Container(
          height: 65.h,
          width: 250.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            border: Border.all(color: primary, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
                fontFamily: 'LatoBold', fontSize: 14.sp, color: primary),
          ),
        ),
      ),
    );
  }
}
