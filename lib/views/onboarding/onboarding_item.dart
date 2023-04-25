import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingItem extends StatelessWidget {
  /*final Widget title;
  final Widget subtitle;*/
  final double overlayOpacity;
  final String image;

  const OnBoardingItem({
    Key? key,
    required this.image,
    /*required this.title,
    required this.subtitle,*/
    this.overlayOpacity = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/$image'),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Color(0x33000000), BlendMode.darken),
        ),
      ),
    );
  }
}
