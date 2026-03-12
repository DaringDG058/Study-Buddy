import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/screens/main/attendance_screen.dart';
import 'package:study_buddy/screens/main/documents_screen.dart';
import 'package:study_buddy/screens/main/study_materials_screen.dart';
import 'package:study_buddy/screens/main/study_tracker_screen.dart';
import 'package:study_buddy/screens/main/timetable_screen.dart';
import 'package:study_buddy/utils/themes.dart';
import 'package:study_buddy/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to Study Tracker

  static const List<Widget> _widgetOptions = <Widget>[
    AttendanceScreen(),
    TimetableScreen(),
    StudyTrackerScreen(),
    DocumentsScreen(),
    StudyMaterialsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appName = Provider.of<ImageStorageProvider>(context).appDisplayName;

    return Scaffold(
      appBar: AppBar(
        title: Text(appName, style: kAppNameStyle),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text('✅', style: TextStyle(fontSize: 24)),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Text('🗓️', style: TextStyle(fontSize: 24)),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Text('🎯', style: TextStyle(fontSize: 24)),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Text('📁', style: TextStyle(fontSize: 24)),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Text('📚', style: TextStyle(fontSize: 24)),
            label: 'Materials',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}