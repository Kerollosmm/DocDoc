import 'package:doc_app/core/routing/routes.dart';
import 'package:doc_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back',
              style: TextStyles.font24BlackBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Sign in to manage attendance and results.',
              style: TextStyles.font13GrayRegular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.roleGateScreen);
              },
              child: const Text('Continue'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.roleGateScreen);
              },
              child: const Text('Choose role directly'),
            ),
          ],
        ),
      ),
    );
  }
}
