import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/screens/auth/register_screen.dart';
import 'package:study_buddy/screens/home_screen.dart';
import 'package:study_buddy/utils/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Provider.of<AuthProvider>(context, listen: false)
          .login(_usernameController.text, _passwordController.text);

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid username or password.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('STUDY BUDDY', style: kAppNameStyle),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a username' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a password' : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  },
                  child: const Text('New here? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}