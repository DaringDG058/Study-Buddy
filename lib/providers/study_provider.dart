import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/models/study_session.dart';

class StudyProvider with ChangeNotifier {
  final SharedPreferences prefs;
  List<String> _subjects = [];
  List<StudySession> _sessions = [];

  List<String> get subjects => _subjects;
  List<StudySession> get sessions => _sessions;

  StudyProvider(this.prefs) {
    _loadSubjects();
    _loadSessions();
  }

  void _loadSubjects() {
    _subjects = prefs.getStringList('subjects') ?? ['Math', 'Science'];
    notifyListeners();
  }

  Future<void> _saveSubjects() async {
    await prefs.setStringList('subjects', _subjects);
  }

  Future<void> addSubject(String subject) async {
    if (!_subjects.contains(subject)) {
      _subjects.add(subject);
      await _saveSubjects();
      notifyListeners();
    }
  }

  Future<void> deleteSubject(String subject) async {
    _subjects.remove(subject);
    await _saveSubjects();
    notifyListeners();
  }

  void _loadSessions() {
    final sessionsData = prefs.getString('study_sessions');
    if (sessionsData != null) {
      final List<dynamic> decoded = json.decode(sessionsData);
      _sessions = decoded.map((item) => StudySession.fromJson(item)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveSessions() async {
    final List<Map<String, dynamic>> encoded = _sessions.map((s) => s.toJson()).toList();
    await prefs.setString('study_sessions', json.encode(encoded));
  }

  Future<void> addSession(StudySession session) async {
    _sessions.add(session);
    await _saveSessions();
    notifyListeners();
  }
}