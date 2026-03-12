import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _getExtension(String path) {
  final dot = path.lastIndexOf('.');
  return dot != -1 ? path.substring(dot) : '';
}

class ImageStorageProvider with ChangeNotifier {
  final SharedPreferences prefs;
  final ImagePicker _picker = ImagePicker();

  String? _profilePicPath;
  String? _timetablePath;
  String _appDisplayName = 'Study Buddy';
  String _attendanceUrl = 'https://parents.msrit.edu/';
  List<Map<String, String>> _documents = [];
  List<Map<String, String>> _links = [];

  ImageStorageProvider(this.prefs) {
    _loadAll();
  }

  // ───── Getters ─────

  String? get profilePicPath => _profilePicPath;
  String? get timetablePath => _timetablePath;
  String get appDisplayName => _appDisplayName;
  String get attendanceUrl => _attendanceUrl;
  List<Map<String, String>> get documents => List.unmodifiable(_documents);
  List<Map<String, String>> get links => List.unmodifiable(_links);

  // ───── Load from SharedPreferences ─────

  void _loadAll() {
    _profilePicPath = prefs.getString('profilePicPath');
    _timetablePath = prefs.getString('timetablePath');
    _appDisplayName = prefs.getString('appDisplayName') ?? 'Study Buddy';
    _attendanceUrl = prefs.getString('attendanceUrl') ?? 'https://parents.msrit.edu/';

    final docsJson = prefs.getString('documents');
    if (docsJson != null) {
      final List<dynamic> decoded = jsonDecode(docsJson);
      _documents = decoded.map((e) => Map<String, String>.from(e)).toList();
    }

    final linksJson = prefs.getString('links');
    if (linksJson != null) {
      final List<dynamic> decoded = jsonDecode(linksJson);
      _links = decoded.map((e) => Map<String, String>.from(e)).toList();
    }
  }

  // ───── Profile Picture ─────

  Future<void> pickAndSetProfilePic() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Copy to app's persistent directory
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_pic_${DateTime.now().millisecondsSinceEpoch}${_getExtension(image.path)}';
    final savedFile = await File(image.path).copy('${dir.path}/$fileName');

    _profilePicPath = savedFile.path;
    await prefs.setString('profilePicPath', savedFile.path);
    notifyListeners();
  }

  void setProfilePicPath(String path) {
    _profilePicPath = path;
    prefs.setString('profilePicPath', path);
    notifyListeners();
  }

  // ───── Timetable ─────

  Future<void> pickAndSetTimetable() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'timetable_${DateTime.now().millisecondsSinceEpoch}${_getExtension(image.path)}';
    final savedFile = await File(image.path).copy('${dir.path}/$fileName');

    _timetablePath = savedFile.path;
    await prefs.setString('timetablePath', savedFile.path);
    notifyListeners();
  }

  // ───── App Display Name ─────

  void setAppDisplayName(String name) {
    _appDisplayName = name;
    prefs.setString('appDisplayName', name);
    notifyListeners();
  }

  // ───── Attendance URL ─────

  void setAttendanceUrl(String url) {
    _attendanceUrl = url;
    prefs.setString('attendanceUrl', url);
    notifyListeners();
  }

  // ───── Documents ─────

  Future<void> addDocument(String name) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}${_getExtension(image.path)}';
    final savedFile = await File(image.path).copy('${dir.path}/$fileName');

    _documents.add({'name': name, 'path': savedFile.path});
    await _saveDocuments();
    notifyListeners();
  }

  void renameDocument(int index, String newName) {
    if (index >= 0 && index < _documents.length) {
      _documents[index] = {
        'name': newName,
        'path': _documents[index]['path']!,
      };
      _saveDocuments();
      notifyListeners();
    }
  }

  void deleteDocument(int index) {
    if (index >= 0 && index < _documents.length) {
      // Try to delete the file from disk
      final path = _documents[index]['path'];
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
      }
      _documents.removeAt(index);
      _saveDocuments();
      notifyListeners();
    }
  }

  Future<void> _saveDocuments() async {
    await prefs.setString('documents', jsonEncode(_documents));
  }

  // ───── Links ─────

  void addLink(String name, String url) {
    _links.add({'name': name, 'url': url});
    _saveLinks();
    notifyListeners();
  }

  void renameLink(int index, String newName) {
    if (index >= 0 && index < _links.length) {
      _links[index] = {
        'name': newName,
        'url': _links[index]['url']!,
      };
      _saveLinks();
      notifyListeners();
    }
  }

  void deleteLink(int index) {
    if (index >= 0 && index < _links.length) {
      _links.removeAt(index);
      _saveLinks();
      notifyListeners();
    }
  }

  Future<void> _saveLinks() async {
    await prefs.setString('links', jsonEncode(_links));
  }
}
