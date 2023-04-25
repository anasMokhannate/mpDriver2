import 'package:flutter/material.dart';
import 'package:motopickupdriver/views/onboarding/onboarding_item.dart';

class SecondOnBoarding extends StatelessWidget {
  const SecondOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnBoardingItem(
      image: 'onboarding-2.png',
      /*title: Text('Nos chauffeurs portent le label "Razine"'),
      subtitle: _DescList(),*/
    );
  }
}

class _DescList extends StatelessWidget {
  const _DescList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('• Bonne conduite'),
        Text('• Éthique'),
        Text('• Bon comportement'),
      ],
    );
  }
}
