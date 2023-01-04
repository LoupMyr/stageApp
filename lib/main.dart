import 'package:flutter/material.dart';
import 'package:stage/myhomepage.dart';
import 'package:stage/ajoutPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de stock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gestion - Accueil'
      ),
      routes: <String, WidgetBuilder>{
        '/routeAjout': (BuildContext context) =>
        const AjoutPage(title: "Gestion - Ajouter un élément"),
      }
    );
  }
}
