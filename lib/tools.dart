import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Tools {

  Future<dynamic> getMateriels() async {
    http.Response response = await http.get(Uri.parse('https://s3-4428.nuage-peda.fr/stockApi/public/api/materiels'));
    return convert.jsonDecode(response.body);
  }
}