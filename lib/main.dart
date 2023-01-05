import 'package:flutter/material.dart';
import 'package:stage/listePage.dart';
import 'package:stage/materielPage.dart';
import 'package:stage/myhomepage.dart';
import 'package:stage/ajoutPage.dart';
import 'package:stage/searchByEtat.dart';
import 'package:stage/searchByType.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gestion de stock',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Gestion - Accueil'),
        darkTheme: ThemeData.dark(),
        routes: <String, WidgetBuilder>{
          '/routeAjout': (BuildContext context) =>
              const AjoutPage(title: "Gestion - Ajouter un élément"),
          '/routeListe': (BuildContext context) =>
              const ListePage(title: "Gestion - Liste du stock"),
          '/routeMateriel': (BuildContext context) =>
              const MaterielPage(title: "Gestion - Detail"),
          '/routeByEtat': (BuildContext context) =>
              const SearchByEtat(title: "Gestion - Recherche par Etat"),
          '/routeByType': (BuildContext context) =>
              const SearchByType(title: "Gestion - Recherche par Type"),
        });
  }
}
