import 'package:flutter/material.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';

class Widgets {
  static Future<void> buildNonAdmin(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Accès non autorisé'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Vous n\'êtes pas administrateur, impossible de continuer'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static Future<void> buildDeletePopUp(String id, var listMateriels,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    Tools tools = Tools();
    return showDialog(
        context: scaffoldKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(Strings.deleteEltTitle),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(Strings.deleteStr),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(Strings.yesButtonStr),
                onPressed: () async {
                  await tools.deleteElt(id, listMateriels, scaffoldKey);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(Strings.cancelButtonStr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static List<Widget> createHeaders(
      BuildContext context, TextStyle _textStyleHeaders) {
    List<Widget> tab = [
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 5,
        child: null,
      ),
    ];
    for (int i = 0; i < 3; i++) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 5,
          child: Text(Strings.tabHeaders[i], style: _textStyleHeaders),
        ),
      );
    }

    return tab;
  }

  static Widget createRow(var elt, var type, TextStyle ts,
      List<dynamic> tableau, AssetImage img, BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, "/routeMateriel", arguments: tableau),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            thickness: 10,
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 7,
            child: Center(
                child: Image(
              image: img,
              color: Colors.black,
            )),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 5,
            child: Center(
              child: Text(type['libelle'], style: ts),
            ),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 5,
            child: Center(
              child: Text(elt['marque'], style: ts),
            ),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 5,
            child: Center(
              child: Text(elt['modele'], style: ts),
            ),
          ),
        ],
      ),
    );
  }
}
