import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:stage/class/local.dart';

class Tools {
  static String role = '';
  //**********//
  //   GET   //
  //*********//

  Future<http.Response> getMateriels() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(
        Uri.parse(
            'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getTypes() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/types'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getType(int id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(
        Uri.parse(
            'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/types/${id.toString()}'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getEtats() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/etats'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getUsers() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/users'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getEtatById(int id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    String url =
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/etats/${id.toString()}';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
    return response;
  }

  Future<http.Response> getUser() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    String? id = await Local.storage.read(key: 'id');
    String url =
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/users/${id.toString()}';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
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
      String etatId,
      String numSerie,
      String numInventaire,
      String lieuInstallation) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
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
      "numSerie": numSerie,
      "numInventaire": numInventaire,
      "lieuInstallation": lieuInstallation
    };

    print(body.toString());
    return await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels'),
      headers: <String, String>{
        "Authorization": "Bearer ${token!}",
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> authenticationUser(String email, String mdp) async {
    final Map<String, dynamic> body = {
      "email": email,
      "password": mdp,
    };
    var response = await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/authentication_token'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
    return response;
  }

  Future<void> updateToken() async {
    final Map<String, dynamic> body = {
      "email": await Local.storage.read(key: 'email'),
      "password": await Local.storage.read(key: 'password'),
    };
    var response = await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/authentication_token'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
    var token = convert.jsonDecode(response.body);
    await Local.storage.write(key: 'token', value: token['token']);
  }

  Future<http.Response> postUser(String email, String mdp) async {
    final Map<String, dynamic> body = {
      "email": email,
      "roles": ["ROLE_USER"],
      "password": mdp
    };

    var response = await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> postPhoto(String url, String uri) async {
    final Map<String, dynamic> body = {"url": url, "password": uri};
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/photos'),
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
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.delete(
        Uri.parse(
            'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels/$id'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

//*******//
// PATCH //
//*******//

  Future<http.Response> patchUserEmail(String id, String email) async {
    var json = convert.jsonEncode(<String, dynamic>{"email": email});
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/users/$id'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
          "Authorization": "Bearer ${token!}"
        },
        body: json);
  }

  Future<http.Response> patchMaterielPhoto(
      List<String> listUriPhotos, String idMateriel) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    var json = convert.jsonEncode(<String, dynamic>{"photos": listUriPhotos});
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels/$idMateriel'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
          "Authorization": "Bearer ${token!}"
        },
        body: json);
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

  Future<bool> checkAdmin() async {
    bool estAdmin = false;
    if (await Local.storage.read(key: 'role') == "ROLE_ADMIN") {
      estAdmin = true;
    }
    return estAdmin;
  }
}
