import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/utils/themes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<AuthProvider>(context, listen: false)
          .register(_usernameController.text, _passwordController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account created successfully! Please log in.'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Create Account', style: kAppNameStyle),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Create Username'),
                  validator: (value) =>
                      value!.isEmpty ? 'Username cannot be empty' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Create Password'),
                  validator: (value) =>
                      value!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}