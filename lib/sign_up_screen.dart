import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String usuario;
  late String contrasena;

  void createFirebaseAccount(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                labelText: 'Ingrese un usuario',
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
                labelText: 'Ingrese una contraseña',
              ),
            ),
            TextButton(
                onPressed: () {
                  createFirebaseAccount(email: usuario, password: contrasena);
                },
                child: const Text("Crear usuario en Firebase"))
          ],
        ),
      ),
    );
  }
}
