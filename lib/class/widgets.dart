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
}
