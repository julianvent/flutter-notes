import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutterino/constants/routes.dart';
import 'package:flutterino/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    //var style = TextStyle(color: Theme.of(context).colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          TextFormField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
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
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                if (!context.mounted) return;

                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) return;

                if (e.code == 'weak-password') {
                  await showErrorDialog(context, 'Weak password');
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, 'Email already in use');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Invalid email entered');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                if (!context.mounted) return;
                await showErrorDialog(context, 'Error: ${e.toString()}');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed:
                () => {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (route) => false),
                },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
