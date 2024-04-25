class QuizProgress {
  int score;
  int totalQuestions;

  QuizProgress({
    required this.score,
    required this.totalQuestions,
  });

  factory QuizProgress.fromMap(Map<String, dynamic> map) {
    return QuizProgress(
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
    };
  }
}
