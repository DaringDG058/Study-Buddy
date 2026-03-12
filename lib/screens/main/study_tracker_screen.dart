import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/models/study_session.dart';
import 'package:study_buddy/providers/study_provider.dart';

// Enums to manage the state
enum TimerMode { stopwatch, timer }
enum StatPeriod { today, yesterday, last7, last30, overall }

class StudyTrackerScreen extends StatefulWidget {
  const StudyTrackerScreen({super.key});

  @override
  State<StudyTrackerScreen> createState() => _StudyTrackerScreenState();
}

class _StudyTrackerScreenState extends State<StudyTrackerScreen> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;
  String? _selectedSubject;

  // New state variables for Timer/Stopwatch mode
  TimerMode _mode = TimerMode.stopwatch;
  Duration _timerSetDuration = const Duration(minutes: 25); // Default timer

  StatPeriod _selectedPeriod = StatPeriod.today;

  @override
  void initState() {
    super.initState();
    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
    if (studyProvider.subjects.isNotEmpty) {
      _selectedSubject = studyProvider.subjects.first;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!mounted) return;

    if (_mode == TimerMode.stopwatch) {
      setState(() {
        _duration = _duration + const Duration(seconds: 1);
      });
    } else { // Timer mode
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      } else { // Timer finished
        _timer?.cancel();
        setState(() { _isRunning = false; });
        _saveSession(DateTime.now().subtract(_timerSetDuration), _timerSetDuration);
        HapticFeedback.vibrate();
      }
    }
  }

  void _toggleTimer() {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject first!')),
      );
      return;
    }

    if (_isRunning) { // Pausing
      _timer?.cancel();
      if (_mode == TimerMode.stopwatch && _duration > Duration.zero) {
        _saveSession(DateTime.now().subtract(_duration), _duration);
      }
    } else { // Starting
      if (_mode == TimerMode.timer && _duration.inSeconds == 0) {
        setState(() { _duration = _timerSetDuration; });
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    }
    setState(() { _isRunning = !_isRunning; });
  }

  void _resetTimer() {
    _timer?.cancel();
    if (_isRunning && _mode == TimerMode.stopwatch && _duration > Duration.zero) {
      _saveSession(DateTime.now().subtract(_duration), _duration);
    }
    setState(() {
      _isRunning = false;
      _duration = (_mode == TimerMode.timer) ? _timerSetDuration : Duration.zero;
    });
  }
  
  void _saveSession(DateTime startTime, Duration duration) {
     final session = StudySession(
        subject: _selectedSubject ?? 'General',
        startTime: startTime,
        duration: duration,
      );
      Provider.of<StudyProvider>(context, listen: false).addSession(session);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  
  void _showSetTimerDialog() {
    final TextEditingController minutesController = TextEditingController(text: _timerSetDuration.inMinutes.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Timer Duration'),
        content: TextField(
          controller: minutesController,
          decoration: const InputDecoration(labelText: 'Minutes'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Set'),
            onPressed: () {
              final minutes = int.tryParse(minutesController.text);
              if (minutes != null && minutes > 0) {
                setState(() {
                  _timerSetDuration = Duration(minutes: minutes);
                  if (!_isRunning) {
                    _duration = _timerSetDuration;
                  }
                });
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _manageSubjects() {
    final subjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Subjects'),
        content: TextField(
          controller: subjectController,
          decoration: const InputDecoration(labelText: 'New Subject Name'),
        ),
        actions: [
          TextButton(
            child: const Text('Delete Selected'),
            onPressed: () {
              if (_selectedSubject != null) {
                Provider.of<StudyProvider>(context, listen: false).deleteSubject(_selectedSubject!);
                final subjects = Provider.of<StudyProvider>(context, listen: false).subjects;
                setState(() {
                  _selectedSubject = subjects.isNotEmpty ? subjects.first : null;
                });
              }
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (subjectController.text.isNotEmpty) {
                Provider.of<StudyProvider>(context, listen: false).addSubject(subjectController.text);
                 if (_selectedSubject == null) {
                   setState(() {
                     _selectedSubject = subjectController.text;
                   });
                 }
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStats() {
    final allSessions = Provider.of<StudyProvider>(context, listen: false).sessions;
    final now = DateTime.now();
    List<StudySession> filteredSessions;
  
    switch (_selectedPeriod) {
      case StatPeriod.today:
        filteredSessions = allSessions.where((s) => DateUtils.isSameDay(s.startTime, now)).toList();
        break;
      case StatPeriod.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        filteredSessions = allSessions.where((s) => DateUtils.isSameDay(s.startTime, yesterday)).toList();
        break;
      case StatPeriod.last7:
        final weekAgo = now.subtract(const Duration(days: 7));
        filteredSessions = allSessions.where((s) => s.startTime.isAfter(weekAgo)).toList();
        break;
      case StatPeriod.last30:
        final monthAgo = now.subtract(const Duration(days: 30));
        filteredSessions = allSessions.where((s) => s.startTime.isAfter(monthAgo)).toList();
        break;
      case StatPeriod.overall:
        filteredSessions = allSessions;
        break;
    }
  
    Duration total = filteredSessions.fold(Duration.zero, (prev, s) => prev + s.duration);
    
    Map<String, Duration> subjectTotals = {};
    for (var session in filteredSessions) {
      subjectTotals.update(session.subject, (value) => value + session.duration, ifAbsent: () => session.duration);
    }

    return {'total': total, 'details': subjectTotals};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<StudyProvider>(
              builder: (context, studyProvider, child) {
                 return Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedSubject,
                        hint: const Text('Select Subject'),
                        items: studyProvider.subjects
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubject = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: _manageSubjects,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),

            ToggleButtons(
              isSelected: [_mode == TimerMode.stopwatch, _mode == TimerMode.timer],
              onPressed: (index) {
                if (_isRunning) return;
                setState(() {
                  _mode = index == 0 ? TimerMode.stopwatch : TimerMode.timer;
                  _duration = _mode == TimerMode.stopwatch ? Duration.zero : _timerSetDuration;
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Stopwatch')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Timer')),
              ],
            ),
            const SizedBox(height: 20),

            InkWell(
              onTap: _mode == TimerMode.timer && !_isRunning ? _showSetTimerDialog : null,
              borderRadius: BorderRadius.circular(120),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                ),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          _formatDuration(_duration),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRunning
                            ? 'IN PROGRESS'
                            : (_mode == TimerMode.timer && _duration > Duration.zero ? 'TAP TO CHANGE' : 'YET TO START'),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  iconSize: 60,
                  onPressed: _toggleTimer,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined),
                  iconSize: 60,
                  onPressed: _resetTimer,
                ),
              ],
            ),
            const Divider(height: 40),
            
            // ** RESTORED STATS SECTION **
            const Text('Focus Duration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: StatPeriod.values.map((period) {
                return ChoiceChip(
                  label: Text(period.name.toUpperCase()),
                  selected: _selectedPeriod == period,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() { _selectedPeriod = period; });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Builder(builder: (context) {
              final stats = _getStats();
              final Duration totalFocusedTime = stats['total'];
              final Map<String, Duration> subjectDetails = stats['details'];

              return Column(
                children: [
                  Text(
                    'Total: ${_formatDuration(totalFocusedTime)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (subjectDetails.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No sessions recorded for this period.', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...subjectDetails.entries.map((entry) => ListTile(
                      title: Text(entry.key),
                      trailing: Text(_formatDuration(entry.value)),
                    )).toList(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}