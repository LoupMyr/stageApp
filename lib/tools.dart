import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Tools {
  //**********//
  //   GET   //
  //*********//

  Future<http.Response> getMateriels() async {
    return await http.get(Uri.parse(
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels'));
  }

  Future<http.Response> getTypes() async {
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/types'));
  }

  Future<http.Response> getType(int id) async {
    return await http.get(Uri.parse(
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/types/${id.toString()}'));
  }

  Future<http.Response> getEtats() async {
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/etats'));
  }

  Future<http.Response> getEtatById(int id) async {
    String url =
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/etats/${id.toString()}';
    print(url);
    var response = await http.get(Uri.parse(url));
    return response;
  }

  //***********//
  //   POST   //
  //**********//

  Future<http.Response> postMateriel(
      String marque,
      String modele,
      String dateAchat,
      String dateGarantie,
      String remarques,
      String typeId,
      String etatId) async {
    Map<String, dynamic> dateA = {};
    Map<String, dynamic> dateG = {};
    Map<String, dynamic> rem = {};
    if (dateAchat.isNotEmpty) {
      dateA = {
        "dateAchat": dateAchat,
      };
    }
    if (dateGarantie.isNotEmpty) {
      dateG = {
        "dateFinGaranti": dateGarantie,
      };
    }
    if (remarques.isNotEmpty) {
      rem = {
        "remarques": remarques,
      };
    }

    final Map<String, dynamic> body = {
      "marque": marque,
      "modele": modele,
      ...dateA,
      ...dateG,
      ...rem,
      "type": '/stageAppWeb/public/api/types/$typeId',
      "etat": '/stageAppWeb/public/api/etats/$etatId',
    };
    return http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
  }

  //************//
  //   DELETE   //
  //************//

  Future<http.Response> deleteMateriel(String id) async {
    return await http.delete(Uri.parse(
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels/$id'));
  }

  //*********//
  // METHODS //
  //*********//

  AssetImage findImg(var type) {
    AssetImage img = const AssetImage('lib/assets/other.png');
    switch (type) {
      case 'Unité centrale':
        img = const AssetImage('lib/assets/pc.png');
        break;
      case 'Ecran':
        img = const AssetImage('lib/assets/ecran.png');

        break;
      case 'Clavier':
        img = const AssetImage('lib/assets/clavier.png');

        break;
      case 'Souris':
        img = const AssetImage('lib/assets/souris.png');

        break;
      case 'Imprimante':
        img = const AssetImage('lib/assets/imprimante.png');

        break;
      case 'Copieur':
        img = const AssetImage('lib/assets/copieur.png');

        break;
      case 'NAS':
        img = const AssetImage('lib/assets/nas.png');

        break;
      case 'Serveur':
        img = const AssetImage('lib/assets/serveur.png');

        break;
      case 'Switch':
        img = const AssetImage('lib/assets/switch.png');

        break;
      case 'Point accès wifi':
        img = const AssetImage('lib/assets/wifi.png');

        break;
      case 'ENI':
        img = const AssetImage('lib/assets/board.png');

        break;
      case 'TBI':
        img = const AssetImage('lib/assets/board.png');

        break;
    }
    return img;
  }
}
