import 'package:flutter/material.dart';

class MotivationScreen extends StatelessWidget {
  const MotivationScreen({super.key});

  final List<Map<String, String>> quotes = const [
    {'quote': 'The secret of getting ahead is getting started.', 'author': 'Mark Twain'},
    {'quote': 'It’s not whether you get knocked down, it’s whether you get up.', 'author': 'Vince Lombardi'},
    {'quote': 'The future belongs to those who believe in the beauty of their dreams.', 'author': 'Eleanor Roosevelt'},
    {'quote': 'Well done is better than well said.', 'author': 'Benjamin Franklin'},
    {'quote': 'Strive for progress, not perfection.', 'author': 'Unknown'},
    {'quote': 'You are the only one who can limit your greatness.', 'author': 'Unknown'},
    {'quote': 'Believe you can and you’re halfway there.', 'author': 'Theodore Roosevelt'},
    {'quote': 'The expert in anything was once a beginner.', 'author': 'Helen Hayes'},
    {'quote': 'The journey of a thousand miles begins with a single step.', 'author': 'Lao Tzu'},
    {'quote': 'Don’t watch the clock; do what it does. Keep going.', 'author': 'Sam Levenson'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation Bar'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${quotes[index]['quote']}"',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- ${quotes[index]['author']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}