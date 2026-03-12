class StudySession {
  final String subject;
  final DateTime startTime;
  final Duration duration;

  StudySession({
    required this.subject,
    required this.startTime,
    required this.duration,
  });

  // For storing in shared_preferences
  Map<String, dynamic> toJson() => {
        'subject': subject,
        'startTime': startTime.toIso8601String(),
        'duration': duration.inSeconds,
      };

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        subject: json['subject'],
        startTime: DateTime.parse(json['startTime']),
        duration: Duration(seconds: json['duration']),
      );
}