import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Tools {
  Future<http.Response> getMateriels() async {
    return await http.get(Uri.parse(
        'http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/materiels'));
  }

  Future<http.Response> getTypes() async {
    return await http.get(
        Uri.parse('http://s3-4428.nuage-peda.fr/stageAppWeb/public/api/types'));
  }

  Future<http.Response> postMateriel(
      String marque,
      String modele,
      String dateAchat,
      String dateGarantie,
      String remarques,
      String typeId) async {
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
    };
    print(body);
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
}
