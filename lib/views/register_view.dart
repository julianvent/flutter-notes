import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterino/firebase_options.dart';

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
    var style = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: style,)
        , backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextFormField(
                      controller: _email, 
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email here', 
                      ),
                    ),
                    TextFormField(
                      controller: _password, 
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'Enter your password here', 
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email
                            , password: password
                          );
                          print(userCredentials);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('you weak');
                          } else if (e.code == 'email-already-in-use') {
                            print('email repeated');
                          } else if (e.code == 'invalid-email')  {
                            print('not quite my email');
                          } else {
                            print(e.code);
                          }
                        }
                      }, 
                      child: const Text('Register'),
                    ),
                  ],
                );
              default: 
                return const Text('Loading...');
            }
          },
        ),
    );
  }
}