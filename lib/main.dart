import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterino/firebase_options.dart';
import 'package:flutterino/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const HomePage(),
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: style,)
        , backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  print('Verified');
                } else {
                  print('Verify your email');
                }
                return const Text('Done');
              default: 
                return const Text('Loading...');
            }
          },
        ),
    );
  }
}
