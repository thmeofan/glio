import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glio/views/quiz/views/question_screen.dart';
import 'package:glio/views/quiz/widgets/progress_bar.dart';

import '../../../consts/app_colors.dart';
import '../../../consts/app_text_styles/categories_text_style.dart';
import '../../../consts/app_text_styles/settings_text_style.dart';
import '../../../data/model/quiz_model.dart';
import '../../../data/model/quiz_progress_model.dart';
import '../../../data/repository/quiz_progress_manager.dart';
import '../../app/widgets/chosen_action_button_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizProgress> _quizProgress = [];

  @override
  void initState() {
    super.initState();
    _loadQuizProgress();
    QuizProgressManager.onQuizProgressSaved = _loadQuizProgress;
  }

  @override
  void dispose() {
    QuizProgressManager.onQuizProgressSaved = null;
    super.dispose();
  }

  Future<void> _loadQuizProgress() async {
    List<QuizProgress> progress = await QuizProgressManager.getQuizProgress();
    setState(() {
      _quizProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blackColor,
      ),
      body: Container(
        color: AppColors.blackColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: size.width * 0.03),
                Text(
                  'Quiz',
                  style: SettingsTextStyle.title,
                ),
              ],
            ),
            _quizProgress.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SvgPicture.asset(
                        'assets/images/quiz.svg',
                        width: size.width * 0.9,
                        height: size.height * 0.3,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Check how much you know about finance',
                          style: CategoriesTextStyle.resultSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _quizProgress.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.darkBlueColor.withOpacity(0.5),
                            ),
                            child: ListTile(
                              title: ProgressBar(
                                questions: questions,
                                questionNumber:
                                    _getRandomScore(questions.length),
                              ),
                              trailing: Text(
                                '${_getRandomScore(questions.length - 1)}/${questions.length}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(
              height: size.height * 0.03,
            ),
            ChosenActionButton(
              text: 'Start',
              onTap: () => navigateToQuiz(context, questions),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  int _getRandomScore(int maxScore) {
    final random = Random();
    return random.nextInt(maxScore - 5) + 6;
  }

  void navigateToQuiz(BuildContext context, List<Question> questions) {
    void resetQuestions() {
      for (var question in questions) {
        question.isLocked = false;
        question.selectedOption = null;
      }
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QuestionScreen(
        questions: questions,
        onRetakeQuiz: resetQuestions,
      ),
    ));
  }
}
