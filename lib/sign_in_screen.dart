import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_autenticacion/my_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late String usuario;
  late String contrasena;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signInFirebaseAccount(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(
          usuario: credential.user!.uid.toString(),
          analytics: analytics,
          observer: observer,
        );
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: "@dominio.com",
                onChanged: (value) {
                  setState(() {
                    usuario = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ingrese su usuario',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    contrasena = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ingrese su contraseña',
                ),
              ),
              TextButton(
                  onPressed: () {
                    signInFirebaseAccount(email: usuario, password: contrasena);
                  },
                  child: const Text("Iniciar sesión en Firebase")),
              TextButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: const Text("Iniciar sesión en Google"))
            ],
          ),
        ),
      ),
    );
  }
}
