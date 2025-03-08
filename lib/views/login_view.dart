import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutterino/constants/routes.dart';
import 'package:flutterino/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var style = TextStyle(color: Theme.of(context).colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Enter your email here'),
          ),
          TextFormField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                
                // Verifica que el widget sigue en pantalla
                if (!context.mounted) return;

                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(
                    context,
                  ).pushNamed(verifyEmailRoute);
                }

              } on FirebaseAuthException catch (e) {
                if (!context.mounted) return;

                if (e.code == 'invalid-credential') {
                  await showErrorDialog(context, 'Wrong credentials');
                } else {
                  await showErrorDialog(context, e.code);
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed:
                () => {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(registerRoute, (route) => false),
                },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
