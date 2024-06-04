import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votaciones/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( Votaciones());
}

class Votaciones extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
     theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Establecer el color de fondo de la aplicación como negro
      ),
      home:  HomeScreen (),
    );
  }
}

