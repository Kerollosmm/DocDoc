import 'package:doc_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text("Login Screen", style: TextStyles.font13DarkBlueMedium),
          ),
        ],
      ),
    );
  }
}
