import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/views/onboarding/first_onboarding.dart';
import 'package:motopickupdriver/views/onboarding/second_onboarding.dart';
import 'package:motopickupdriver/views/welcome_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final Duration _duration = const Duration(milliseconds: 200);
  final Curve _curve = Curves.easeIn;
  final PageController _pageController = PageController();
  final List<Widget> _pages = const [
    FirstOnBoarding(),
    SecondOnBoarding(),
  ];
  int index = 0;

  Widget _buildIndicator(BuildContext context, int forIndex) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      height: 10.r,
      width: (index == forIndex ? 60 : 25).r,
      decoration: const ShapeDecoration(
        shape: StadiumBorder(side: BorderSide.none),
        color: Colors.white,
      ),
    );
  }

  void next() {
    if (index == _pages.length - 1) {
      Get.offAll(() => WelcomeScreen());
    } else {
      _pageController.nextPage(duration: _duration, curve: _curve);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          _pageController.previousPage(duration: _duration, curve: _curve);
          return false;
        }
        return true;
      },
      child: Material(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => index = i),
              children: _pages,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(
                  flex: 2,
                  /*child: Center(
                    child: Hero(
                      tag: 'logo',
                      child: Image(
                        image: const AssetImage('assets/images/logo.webp'),
                        width: 110.r,
                      ),
                    ),
                  ),*/
                ),
                const Spacer(flex: 3),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(context, 0),
                          18.horizontalSpace,
                          _buildIndicator(context, 1),
                        ],
                      ),
                      24.verticalSpace,
                      InkWell(
                        onTap: next,
                        child: Center(
                          child: Container(
                            height: 65.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(360),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedCrossFade(
                              firstChild: Text(
                                'suivant',
                                style: TextStyle(
                                  fontFamily: 'LatoBold',
                                  fontSize: 14.sp,
                                  color: dark,
                                ),
                              ).tr(),
                              secondChild: Text(
                                "parti",
                                style: TextStyle(
                                  fontFamily: 'LatoBold',
                                  fontSize: 14.sp,
                                  color: dark,
                                ),
                              ).tr(),
                              crossFadeState: CrossFadeState
                                  .values[index < _pages.length - 1 ? 0 : 1],
                              duration: _duration,
                              sizeCurve: _curve,
                              firstCurve: _curve,
                              secondCurve: _curve,
                            ),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Regarder la demo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
