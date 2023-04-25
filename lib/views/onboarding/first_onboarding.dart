import 'package:flutter/material.dart';
import 'package:motopickupdriver/views/onboarding/onboarding_item.dart';

class FirstOnBoarding extends StatelessWidget {
  const FirstOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnBoardingItem(
      image: 'onboarding.jpg',
      /*title: Text('Moto PickUp'),
      subtitle: Text('Le premier service de mobilité par motocyclette au Maroc'),*/
    );
  }
}
