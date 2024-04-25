import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/quiz_progress_model.dart';

class QuizProgressManager {
  static const String _quizProgressKey = 'quiz_progress';

  static void Function()? onQuizProgressSaved;

  static Future<void> saveQuizProgress(QuizProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> progressList = prefs.getStringList(_quizProgressKey) ?? [];
    progressList.add(jsonEncode(progress.toMap()));
    await prefs.setStringList(_quizProgressKey, progressList);

    if (onQuizProgressSaved != null) {
      onQuizProgressSaved!();
    }
  }

  static Future<List<QuizProgress>> getQuizProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? progressList = prefs.getStringList(_quizProgressKey);

    if (progressList == null) {
      return [];
    }

    List<QuizProgress> quizProgressList = [];

    for (String progressData in progressList) {
      try {
        Map<String, dynamic> progressMap = jsonDecode(progressData);
        if (progressMap.containsKey('score') &&
            progressMap.containsKey('totalQuestions')) {
          QuizProgress progress = QuizProgress.fromMap(progressMap);
          quizProgressList.add(progress);
        } else {
          print('Incomplete QuizProgress data: $progressData');
        }
      } catch (e) {
        print('Error parsing QuizProgress data: $e');
      }
    }

    return quizProgressList;
  }
}
