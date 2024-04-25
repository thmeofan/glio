import 'package:flutter/material.dart';

import '../../../consts/app_colors.dart';
import '../../../data/model/quiz_model.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
    required this.questions,
    required this.questionNumber,
  }) : super(key: key);

  final List<Question> questions;
  final int questionNumber;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double progress = questionNumber / questions.length;

    return Container(
      height: size.height * 0.03,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.darkBlueColor,
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth * progress,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: AppColors.lightBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
