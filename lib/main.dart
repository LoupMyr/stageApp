import 'package:flutter/material.dart';
import 'package:stage/connexionPage.dart';
import 'package:stage/inscriptionPage.dart';
import 'package:stage/listePage.dart';
import 'package:stage/listeUsersPage.dart';
import 'package:stage/materielPage.dart';
import 'package:stage/myhomepage.dart';
import 'package:stage/ajoutPage.dart';
import 'package:stage/searchByEtat.dart';
import 'package:stage/searchByType.dart';
import 'package:stage/splashscreen.dart';

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
          primarySwatch: Colors.grey,
        ),
        home: const SplashScreen(title: 'Gestion - Connexion'),
        darkTheme: ThemeData.dark(),
        routes: <String, WidgetBuilder>{
          '/routeHome': (BuildContext context) =>
              const MyHomePage(title: "Gestion - Accueil"),
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
          '/routeInscription': (BuildContext context) =>
              const InscriptionPage(title: "Gestion - Inscription"),
          '/routeListeUsers': (BuildContext context) => const ListeUsersPage(
              title: "Administration - Gestion utilisateurs"),
          '/routeConnexion': (BuildContext context) =>
              const ConnexionPage(title: "Connexion"),
        });
  }
}
