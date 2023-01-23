import 'package:flutter/material.dart';
import 'package:stage/materiel/searchByLieuPage.dart';
import 'package:stage/user/connexionPage.dart';
import 'package:stage/user/inscriptionPage.dart';
import 'package:stage/materiel/listePage.dart';
import 'package:stage/user/listeUsersPage.dart';
import 'package:stage/materiel/materielPage.dart';
import 'package:stage/myhomepage.dart';
import 'package:stage/materiel/ajoutPage.dart';
import 'package:stage/user/profilPage.dart';
import 'package:stage/materiel/qrCodePage.dart';
import 'package:stage/materiel/searchByEtatPage.dart';
import 'package:stage/materiel/searchByTypePage.dart';
import 'package:stage/materiel/searchByDatePage.dart';
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
        home: const SplashScreen(title: 'Connexion'),
        darkTheme: ThemeData.dark(),
        routes: <String, WidgetBuilder>{
          '/routeHome': (BuildContext context) =>
              const MyHomePage(title: "Inventaire du parc informatique"),
          '/routeAjout': (BuildContext context) =>
              const AjoutPage(title: "Ajouter un élément"),
          '/routeListe': (BuildContext context) =>
              const ListePage(title: "Liste du stock"),
          '/routeMateriel': (BuildContext context) =>
              const MaterielPage(title: "Detail"),
          '/routeByEtat': (BuildContext context) =>
              const SearchByEtatPage(title: "Recherche par Etat"),
          '/routeByType': (BuildContext context) =>
              const SearchByTypePage(title: "Recherche par Type"),
          '/routeByDate': (BuildContext context) =>
              const SearchByDatePage(title: "Recherche par Année"),
          '/routeByLieu': (BuildContext context) =>
              const SearchByLieuPage(title: "Recherche par Lieu"),
          '/routeInscription': (BuildContext context) =>
              const InscriptionPage(title: "Inscription"),
          '/routeListeUsers': (BuildContext context) =>
              const ListeUsersPage(title: "Gestion utilisateurs"),
          '/routeConnexion': (BuildContext context) =>
              const ConnexionPage(title: "Connexion"),
          '/routeQrcode': (BuildContext context) =>
              const QrCodePage(title: "QR Code"),
          '/routeProfil': (BuildContext context) =>
              const ProfilPage(title: "Votre profil"),
        });
  }
}
