import 'package:flutter/material.dart';
import 'package:stage/user/connexionPage.dart';
import 'package:stage/user/inscriptionPage.dart';
import 'package:stage/materiel/listePage.dart';
import 'package:stage/user/listeUsersPage.dart';
import 'package:stage/materiel/materielPage.dart';
import 'package:stage/myhomepage.dart';
import 'package:stage/materiel/ajoutPage.dart';
import 'package:stage/user/profilPage.dart';
import 'package:stage/materiel/qrCodePage.dart';
import 'package:stage/materiel/searchByEtat.dart';
import 'package:stage/materiel/searchByType.dart';
import 'package:stage/materiel/searchByDate.dart';
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
          primaryColor: Colors.teal,
        ),
        home: const SplashScreen(title: 'Inventaire parc informatique'),
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
          '/routeByDate': (BuildContext context) =>
              const SearchByDate(title: "Gestion - Recherche par Année"),
          '/routeInscription': (BuildContext context) =>
              const InscriptionPage(title: "Gestion - Inscription"),
          '/routeListeUsers': (BuildContext context) => const ListeUsersPage(
              title: "Administration - Gestion utilisateurs"),
          '/routeConnexion': (BuildContext context) =>
              const ConnexionPage(title: "Connexion"),
          '/routeQrcode': (BuildContext context) =>
              const QrCodePage(title: "Gestion - QR Code"),
          '/routeProfil': (BuildContext context) =>
              const ProfilPage(title: "Votre profil"),
        });
  }
}
