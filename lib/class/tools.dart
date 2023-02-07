import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:stage/class/local.dart';
import 'package:stage/class/strings.dart';

class Tools {
  final String _url = //'http://localhost/stageApi'
      'http://s3-4428.nuage-peda.fr/stageAppWeb';
  //**********//
  //   GET   //
  //*********//

  Future<http.Response> getMateriels() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/materiels'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getTypes() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/types'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getType(int id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/types/${id.toString()}'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getEtats() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/etats'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getUsers() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/users'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> getEtatById(int id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    String url = '$_url/public/api/etats/${id.toString()}';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
    return response;
  }

  Future<http.Response> getLieuById(int id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    var response = await http.get(
        Uri.parse('$_url/public/api/lieus/${id.toString()}'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
    return response;
  }

  Future<http.Response> getUser() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    String? id = await Local.storage.read(key: 'id');
    var response = await http.get(
        Uri.parse('$_url/public/api/users/${id.toString()}'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
    return response;
  }

  Future<http.Response> getPhotos() async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.get(Uri.parse('$_url/public/api/photos'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
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
      String lieuId,
      String detailsAutres) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    Map<String, dynamic> dateA = {};
    Map<String, dynamic> dateG = {};
    Map<String, dynamic> rem = {};
    Map<String, dynamic> details = {};
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
    if (detailsAutres.isNotEmpty) {
      details = {
        "detailTypeAutres": detailsAutres,
      };
    }

    final Map<String, dynamic> body = {
      "marque": marque,
      "modele": modele,
      ...dateA,
      ...dateG,
      ...rem,
      "type": '/stageApi/public/api/types/$typeId',
      "etat": '/stageApi/public/api/etats/$etatId',
      "numSerie": numSerie,
      "numInventaire": numInventaire,
      "lieuInstallation": '/stageApi/public/api/lieus/$lieuId',
      ...details,
    };
    return await http.post(
      Uri.parse('$_url/public/api/materiels'),
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
      Uri.parse('$_url/public/api/authentication_token'),
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
      Uri.parse('$_url/public/api/authentication_token'),
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
      Uri.parse('$_url/public/api/users'),
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
      Uri.parse('$_url/public/api/photos'),
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
    return await http.delete(Uri.parse('$_url/public/api/materiels/$id'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> deletePhoto(String id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.delete(Uri.parse('$_url/public/api/photos/$id'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }

  Future<http.Response> deleteUser(String id) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.delete(Uri.parse('$_url/public/api/users/$id'),
        headers: <String, String>{"Authorization": "Bearer ${token!}"});
  }
//*******//
// PATCH //
//*******//

  Future<http.Response> patchUserEmail(String id, String email) async {
    var json = convert.jsonEncode(<String, dynamic>{"email": email});
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.patch(Uri.parse('$_url/public/api/users/$id'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
          "Authorization": "Bearer ${token!}"
        },
        body: json);
  }

  Future<http.Response> patchUserRole(String id, String role) async {
    var json = convert.jsonEncode(<String, dynamic>{
      "roles": [role]
    });
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    return await http.patch(Uri.parse('$_url/public/api/users/$id'),
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
    return await http.patch(Uri.parse('$_url/public/api/materiels/$idMateriel'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
          "Authorization": "Bearer ${token!}"
        },
        body: json);
  }

  Future<http.Response> patchMateriel(
      String idMateriel,
      String marque,
      String modele,
      String dateAchat,
      String dateGarantie,
      String remarques,
      String typeId,
      String etatId,
      String numSerie,
      String numInventaire,
      String lieuId,
      String detailsAutres) async {
    await updateToken();
    String? token = await Local.storage.read(key: 'token');
    Map<String, dynamic> dateA = {};
    Map<String, dynamic> dateG = {};
    Map<String, dynamic> rem = {};
    Map<String, dynamic> details = {};
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
    if (detailsAutres.isNotEmpty) {
      details = {
        "detailTypeAutres": detailsAutres,
      };
    }
    final Map<String, dynamic> body = {
      "marque": marque,
      "modele": modele,
      ...dateA,
      ...dateG,
      ...rem,
      "type": '/stageApi/public/api/types/$typeId',
      "etat": '/stageApi/public/api/etats/$etatId',
      "numSerie": numSerie,
      "numInventaire": numInventaire,
      "lieuInstallation": '/stageApi/public/api/lieus/$lieuId',
      ...details,
    };
    return await http.patch(Uri.parse('$_url/public/api/materiels/$idMateriel'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
          "Authorization": "Bearer ${token!}"
        },
        body: convert.jsonEncode(body));
  }

//*********//
// METHODS //
//*********//

  AssetImage findImg(var type) {
    AssetImage img = const AssetImage('assets/other.png');
    switch (type) {
      case 'Unité centrale':
        img = const AssetImage('assets/pc.png');
        break;
      case 'Ecran':
        img = const AssetImage('assets/ecran.png');

        break;
      case 'Clavier':
        img = const AssetImage('assets/clavier.png');

        break;
      case 'Souris':
        img = const AssetImage('assets/souris.png');

        break;
      case 'Imprimante':
        img = const AssetImage('assets/imprimante.png');

        break;
      case 'Copieur':
        img = const AssetImage('assets/copieur.png');

        break;
      case 'NAS':
        img = const AssetImage('assets/nas.png');

        break;
      case 'Serveur':
        img = const AssetImage('assets/serveur.png');

        break;
      case 'Switch':
        img = const AssetImage('assets/switch.png');

        break;
      case 'Point accès wifi':
        img = const AssetImage('assets/wifi.png');

        break;
      case 'ENI':
        img = const AssetImage('assets/board.png');

        break;
      case 'TBI':
        img = const AssetImage('assets/board.png');

        break;
      case 'Tablette':
        img = const AssetImage('assets/tablet.png');

        break;
      case 'Téléphone fixe':
        img = const AssetImage('assets/tel-fixe.png');

        break;
      case 'Téléphone mobile':
        img = const AssetImage('assets/tel-portable.png');

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

  Future<bool> checkMods() async {
    bool estMod = false;
    if (await Local.storage.read(key: 'role') == "ROLE_MODERATOR") {
      estMod = true;
    }
    return estMod;
  }

  List<List<dynamic>> sortByType(var types, List<dynamic> listMateriels) {
    List<List<dynamic>> tabSorted = List.generate(
        types['hydra:member'].length, (index) => List.empty(growable: true));
    for (var type in types['hydra:member']) {
      for (var materiel in listMateriels) {
        List<String> temp = materiel['type'].split('/');
        int idType = int.parse(temp[temp.length - 1]);
        if (idType == type['id']) {
          for (int i = 0; i < tabSorted.length; i++) {
            if (idType - 1 == i) {
              tabSorted[i].add(materiel);
            }
          }
        }
      }
    }
    return tabSorted;
  }

  Future<void> deleteElt(String id, var listMateriels,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    for (var elt in listMateriels) {
      if (elt['id'].toString() == id) {
        if (elt['photos'].isNotEmpty) {
          List<int> tabIdPhoto = List.empty(growable: true);
          for (int i = 0; i < elt['photos'].length; i++) {
            List<String> temp = elt['photos'][i].split('/');
            int id = int.parse(temp[temp.length - 1]);
            tabIdPhoto.add(id);
          }
          for (int i = 0; i < tabIdPhoto.length; i++) {
            await this.deletePhoto(tabIdPhoto[i].toString());
          }
        }
      }
    }
    var response = await this.deleteMateriel(id);
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text(Strings.deleteEltSuccessful),
      ));
    } else {
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text(Strings.errorHappened),
      ));
    }
  }

  int splitUri(String str) {
    List<String> temp = str.split('/');
    return int.parse(temp[temp.length - 1]);
  }

  List<dynamic> sortListByDateAchat(List<dynamic> list) {
    List<dynamic> tabEltSansDate = List.empty(growable: true);
    for (var elt in list) {
      try {
        String dateTest = elt['dateAchat'];
      } catch (e) {
        tabEltSansDate.add(elt);
      }
    }
    for (var elt in tabEltSansDate) {
      list.remove(elt);
    }
    list.sort((a, b) {
      return DateTime.parse(b['dateAchat'])
          .compareTo(DateTime.parse(a['dateAchat']));
    });
    list = list + tabEltSansDate;
    return list;
  }

  String guessRole(admin, mod) {
    String role = 'ROLE_USER';
    if (admin) {
      role = 'ROLE_ADMIN';
    } else if (mod && !admin) {
      role = 'ROLE_MODERATOR';
    }
    return role;
  }

  Future<void> createArboresence(String pathDoc) async {
    await Directory('$pathDoc/gestionStock').create();
    await Directory('$pathDoc/gestionStock/qrCodes').create();
    await Directory('$pathDoc/gestionStock/pdfRecap').create();
    await Directory('$pathDoc/gestionStock/pdfFiches').create();
  }

  Future<void> checkArboresence(String pathDoc) async {
    final dirMain = Directory('${pathDoc}/gestionStock');
    if (!await dirMain.exists()) {
      await createArboresence(pathDoc);
    } else {
      if (!await Directory('${dirMain.path}/qrCodes').exists()) {
        await Directory('${dirMain.path}/qrCodes').create();
      }
      if (!await Directory('${dirMain.path}/pdfFiches').exists()) {
        await Directory('${dirMain.path}/pdfFiches').create();
      }
      if (!await Directory('${dirMain.path}/pdfRecap').exists()) {
        await Directory('${dirMain.path}/pdfRecap').create();
      }
    }
  }
}
