import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/screens/auth/login_screen.dart';
import 'package:study_buddy/screens/home_screen.dart';
import 'package:study_buddy/utils/themes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _zoomAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 2), () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isLoggedIn) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _zoomAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('lib/assets/images/logo1.jpeg', height: 150),
                const SizedBox(height: 20),
                Consumer<ImageStorageProvider>(
                  builder: (context, imgProvider, _) {
                    return Text(
                      imgProvider.appDisplayName,
                      style: kAppNameStyle,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}