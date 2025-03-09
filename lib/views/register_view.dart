import 'package:flutter/material.dart';

import 'package:flutterino/constants/routes.dart';
import 'package:flutterino/services/auth/auth_exceptions.dart';
import 'package:flutterino/services/auth/auth_service.dart';
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();

                if (!context.mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'Email is already in use');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'Invalid email entered');
              } on GenericAuthException {
                await showErrorDialog(context, 'Failed to register');
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
