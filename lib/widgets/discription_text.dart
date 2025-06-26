import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Craft your ideal meal effortlessly \n with our app. Select nutritious \n ingredients tailored to your taste \n and well-being.',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w200,
      ),
      textAlign: TextAlign.center,
    );
  }
}
