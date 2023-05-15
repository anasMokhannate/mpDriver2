// ignore_for_file: must_be_immutable

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/queries.dart';
import 'package:motopickupdriver/utils/typography.dart';

import '../utils/models/user.dart';

class ProfileCard extends StatefulWidget {
  IconData icon;
  String text;
  final VoidCallback function;

  ProfileCard(
      {required this.icon,
      required this.text,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          height: 70.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              15.horizontalSpace,
              Icon(
                widget.icon,
                size: 30.h,
              ),
              10.horizontalSpace,
              Text(
                widget.text,
                style: bodyTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TypeOrder extends StatefulWidget {
  bool isActive;
  String text;
  final VoidCallback function;

  TypeOrder(
      {required this.isActive,
      required this.text,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<TypeOrder> createState() => _TypeOrderState();
}

class _TypeOrderState extends State<TypeOrder> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        height: 55.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.transparent : primary,
          border: Border.all(color: primary, width: 1.2),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 14.sp,
            color: widget.isActive ? primary : light,
            fontFamily: "LatoSemiBold",
          ),
        ),
      ),
    );
  }
}

class TypeMoto extends StatefulWidget {
  IconData icon;
  String text;
  bool value;
  final VoidCallback function;
  TypeMoto(
      {required this.icon,
      required this.text,
      required this.value,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<TypeMoto> createState() => _TypeMotoState();
}

class _TypeMotoState extends State<TypeMoto> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        height: 55.h,
        width: 95.w,
        decoration: BoxDecoration(
          color: widget.value ? light : primary,
          border: Border.all(color: primary, width: 1.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            const Spacer(),
            Icon(
              widget.icon,
              color: widget.value ? primary : light,
              size: 20.w,
            ),
            25.horizontalSpace,
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.value ? primary : light,
                fontFamily: 'LatoSemiBold',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class TypeCommand extends StatefulWidget {
  IconData icon;
  String text;
  bool value;
  final VoidCallback function;
  TypeCommand(
      {required this.icon,
      required this.text,
      required this.value,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<TypeCommand> createState() => _TypeCommandState();
}

class _TypeCommandState extends State<TypeCommand> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        height: 50.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: widget.value ? light : primary,
          border: Border.all(color: primary, width: 1.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            const Spacer(),
            Icon(
              widget.icon,
              color: widget.value ? primary : light,
              size: 25.w,
            ),
            25.horizontalSpace,
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.value ? primary : light,
                fontFamily: 'LatoSemiBold',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class DriverCard extends StatefulWidget {
  double distance;
  final VoidCallback function;

  DriverCard({required this.distance, required this.function, Key? key})
      : super(key: key);

  @override
  State<DriverCard> createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w),
      child: Container(
        width: 335.w,
        height: 180.h,
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary,
            width: 0.7,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  15.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mohamed Saidi',
                        style: bodyTextStyle,
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Boxicons.bxs_star,
                            color: primary,
                          ),
                          Icon(
                            Boxicons.bxs_star,
                            color: primary,
                          ),
                          Icon(
                            Boxicons.bxs_star,
                            color: primary,
                          ),
                          Icon(
                            Boxicons.bx_star,
                            color: primary,
                          ),
                          Icon(
                            Boxicons.bx_star,
                            color: primary,
                          )
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1531327431456-837da4b1d562?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
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
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    widget.distance < 6 ? '10 DHS' : '15 DHS',
                    style: bodyTextStyle,
                  ),
                  const Spacer(),
                  Text(
                    '1 - 3min',
                    style: bodyTextStyle,
                  ),
                  const Spacer(),
                  Text(
                    '${widget.distance.toStringAsFixed(1)}km',
                    style: bodyTextStyle,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Refuser',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                        fontFamily: 'LatoSemiBold',
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: widget.function,
                    child: Container(
                      height: 30.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Accepter',
                        style: lightButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommandCard extends StatefulWidget {
  String date;
  String prix;
  String from, to;
  int status;
  VoidCallback? onTap;
  CommandCard(
      {required this.date,
      required this.prix,
      required this.from,
      required this.to,
      required this.status,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<CommandCard> createState() => _CommandCardState();
}

class _CommandCardState extends State<CommandCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        child: Container(
          height: 120.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: border, width: 1.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 45.h,
                  width: 45.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    color: widget.status == 1
                        ? primary.withOpacity(0.2)
                        : widget.status == 0
                            ? Colors.red.withOpacity(0.2)
                            : const Color(0xFFF1E6C2),
                  ),
                  child: Icon(
                    widget.status == 1
                        ? Boxicons.bx_check
                        : widget.status == 0
                            ? Boxicons.bx_x
                            : Boxicons.bx_time,
                    color: widget.status == 1
                        ? primary
                        : widget.status == 0
                            ? Colors.red
                            : const Color(0xFFA39874),
                  ),
                ),
                10.horizontalSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.date,
                            style: bodyTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            'Tarifs : ${widget.prix} MAD',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        'De : ${widget.from}',
                        style: bodyTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    10.verticalSpace,
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        'À : ${widget.to}',
                        style: bodyTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
    }
  }
}

class OrdersCard extends StatefulWidget {
  String photo, username, orderType, from, to, idOrder, distance;
  double stars;
  MpUser drive;
  int status;
  final VoidCallback accepte;
  OrdersCard(
      {required this.photo,
      required this.status,
      required this.username,
      required this.orderType,
      required this.from,
      required this.to,
      required this.idOrder,
      required this.drive,
      required this.distance,
      required this.accepte,
      required this.stars,
      Key? key})
      : super(key: key);

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  double time = 0;
  String timeText = "";
  @override
  Widget build(BuildContext context) {
    time = double.parse(widget.distance) / 50 < 1
        ? double.parse(widget.distance) / 50 * 60
        : double.parse(widget.distance) / 50;
    timeText = double.parse(widget.distance) / 50 < 1
        ? "${time.toStringAsFixed(1)} minutes"
        : "${time.toStringAsFixed(1)} heures";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        height: 230.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        widget.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  15.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: bodyTextStyle,
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            widget.stars >= 1
                                ? Boxicons.bxs_star
                                : Boxicons.bx_star,
                            size: 17.sp,
                            color: primary,
                          ),
                          Icon(
                            widget.stars >= 2
                                ? Boxicons.bxs_star
                                : Boxicons.bx_star,
                            size: 17.sp,
                            color: primary,
                          ),
                          Icon(
                            widget.stars >= 3
                                ? Boxicons.bxs_star
                                : Boxicons.bx_star,
                            size: 17.sp,
                            color: primary,
                          ),
                          Icon(
                            widget.stars >= 4
                                ? Boxicons.bxs_star
                                : Boxicons.bx_star,
                            size: 17.sp,
                            color: primary,
                          ),
                          Icon(
                            widget.stars >= 5
                                ? Boxicons.bxs_star
                                : Boxicons.bx_star,
                            size: 17.sp,
                            color: primary,
                          )
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            widget.orderType == "1"
                                ? Boxicons.bx_package
                                : FontAwesomeIcons.motorcycle,
                            size: 20.h,
                            color: primary,
                          ),
                          15.horizontalSpace,
                          widget.status != 3
                              ? Text(
                                  widget.orderType != "1" ? "Course" : "Voyage",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: primary,
                                    fontFamily: 'LatoSemiBold',
                                  ),
                                )
                              : Text(
                                  widget.orderType != "1"
                                      ? "Course planifié"
                                      : "Voyage planifié",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: primary,
                                    fontFamily: 'LatoSemiBold',
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${widget.distance} Km\n( $timeText )',
                    style: bodyTextStyle,
                  ),
                ],
              ),
              20.verticalSpace,
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
                            borderRadius: BorderRadius.circular(360)),
                      ),
                      Icon(
                        Boxicons.bxs_circle,
                        size: 10.h,
                      ),
                    ],
                  ),
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 280.w,
                        child: Text(
                          "De : ${widget.from}",
                          overflow: TextOverflow.ellipsis,
                          style: bodyTextStyle,
                        ),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        width: 280.w,
                        child: Text(
                          "À : ${widget.to}",
                          overflow: TextOverflow.ellipsis,
                          style: bodyTextStyle,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                       refuserOrder(widget.drive, widget.idOrder);
                    },
                    child: Container(
                      height: 40.h,
                      width: 150.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: light,
                        border: Border.all(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Refuser',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.red,
                          height: 1.2,
                          fontFamily: "LatoRegular",
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: widget.accepte,
                    child: Container(
                      height: 40.h,
                      width: 150.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primary,
                        border: Border.all(
                          color: primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Accepter',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: light,
                          height: 1.2,
                          fontFamily: "LatoRegular",
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
