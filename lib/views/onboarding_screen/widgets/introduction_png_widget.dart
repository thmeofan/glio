import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroductionPNGWidget extends StatelessWidget {
  final String imagePath;

  const IntroductionPNGWidget({
    key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.transparent.withOpacity(1),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }
}
