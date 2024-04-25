import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:async';
import 'dart:ui' as ui;
import '../../../consts/app_colors.dart';
import '../../../consts/app_text_styles/categories_text_style.dart';
import '../../../consts/app_text_styles/settings_text_style.dart';
import '../../../data/model/quiz_model.dart';
import '../../../data/model/quiz_progress_model.dart';
import '../../../data/repository/quiz_progress_manager.dart';
import '../../app/widgets/chosen_action_button_widget.dart';
import '../widgets/option_widget.dart';
import '../widgets/progress_bar.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key, required this.questions, this.onRetakeQuiz});

  final List<Question> questions;
  final VoidCallback? onRetakeQuiz;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  int _questionNumber = 1;
  bool _isQuizFinished = false;

  int calculateScore() {
    int score = 0;
    for (var question in widget.questions) {
      if (question.isLocked && question.selectedOption?.isCorrect == true) {
        score++;
      }
    }
    return score;
  }

  void saveQuizProgress() {
    int score = calculateScore();
    QuizProgress progress = QuizProgress(
      score: score,
      totalQuestions: widget.questions.length,
    );
    QuizProgressManager.saveQuizProgress(progress);
  }

  void resetQuiz() {
    setState(() {
      _isQuizFinished = false;
      _questionNumber = 1;
      _controller.jumpToPage(0);
    });
    for (var question in widget.questions) {
      question.isLocked = false;
      question.selectedOption = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        titleSpacing: -5,
        title: const Text(
          'Back',
          style: SettingsTextStyle.back,
        ),
        actions: [Text('$_questionNumber/${widget.questions.length}')],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            'assets/icons/leading.svg',
            width: size.width * 0.04,
            height: size.width * 0.04,
            // color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: AppColors.blackColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProgressBar(
              questions: widget.questions,
              questionNumber: _questionNumber,
            ),
            SizedBox(
              height: size.width * 0.015,
            ),
            Container(
              height: size.height * 0.5,
              child: PageView.builder(
                itemCount: widget.questions.length,
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (_isQuizFinished) {}
                  final question = widget.questions[index];
                  return buildQuestion(question);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(Question? question) {
    Size size = MediaQuery.of(context).size;
    if (_isQuizFinished) {
      String resultImage;
      String resultText;
      int score = calculateScore();
      if (score == widget.questions.length) {
        resultText =
            'You have successfully answered all the questions, way to go!';
        resultImage = 'assets/images/15.svg';
      } else if (score > 10) {
        resultText = 'You have a good grasp of the basics!';
        resultImage = 'assets/images/10.svg';
      } else {
        resultText = 'You\'ll definitely make it next time';
        resultImage = 'assets/images/0.svg';
      }

      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.005,
            ),
            Center(
              child: Text(
                '$score/${widget.questions.length}',
                style: CategoriesTextStyle.result,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    resultImage,
                    height: size.height * 0.225,
                  ),
                  Text(
                    resultText,
                    style: CategoriesTextStyle.resultSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Spacer(),
            ChosenActionButton(
              text: 'Continue',
              onTap: () {
                resetQuiz();
                saveQuizProgress();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: size.height * 0.1,
                width: size.width * 0.88,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    question!.text,
                    style: CategoriesTextStyle.question,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Expanded(
            child: OptionWidget(
                question: question,
                onClickedOption: (option) {
                  if (question.isLocked) {
                    return;
                  } else {
                    setState(() {
                      question.isLocked = true;
                      question.selectedOption = option;
                    });

                    Future.delayed(Duration(seconds: 1), () async {
                      if (_controller.page!.toInt() ==
                          widget.questions.length - 1) {
                        setState(() {
                          _isQuizFinished = true;
                        });
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                        setState(() {
                          _questionNumber += 1;
                        });
                      }
                    });
                  }
                }),
          ),
        ],
      ),
    );
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? AppColors.lightBlueColor : AppColors.redColor;
      } else if (option.isCorrect) {
        return AppColors.lightBlueColor;
      }
    }
    return AppColors.lightBlueColor;
  }
}
