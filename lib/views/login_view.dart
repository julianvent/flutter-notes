import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
    var style = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: style,)
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
                          final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email
                            , password: password
                          );
                          print(userCredentials);
                        } on FirebaseAuthException catch (e){
                          if (e.code == 'invalid-credential') {
                            print('Invalid credentials');
                          }
                        }
                      }, 
                      child: const Text('Login'),
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