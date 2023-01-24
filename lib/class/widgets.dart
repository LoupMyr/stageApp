import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  static List<Widget> createHeaders(BuildContext context) {
    TextStyle textStyleHeaders =
        const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    List<Widget> tab = [
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 5,
        child: null,
      ),
    ];
    for (int i = 0; i < 4; i++) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 5,
          child: Text(Strings.tabHeaders[i], style: textStyleHeaders),
        ),
      );
    }

    return tab;
  }

  static Widget createRowElt(var elt, var type, TextStyle ts,
      List<dynamic> tableau, AssetImage img, BuildContext context) {
    SizedBox sizedbox = const SizedBox();
    try {
      sizedbox = SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Center(
          child: Text(
              DateFormat('yyyy')
                  .format(DateTime.parse(elt['dateAchat']))
                  .toString(),
              style: ts),
        ),
      );
    } catch (e) {
      sizedbox = SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: const Center(child: Icon(Icons.question_mark, size: 40)),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 2.5),
        ),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, "/routeMateriel", arguments: tableau),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 9,
              child: Center(
                  child: Image(
                image: img,
                color: Colors.black,
              )),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 9,
              child: Center(
                child: Text(
                  type['libelle'],
                  style: ts,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 6,
              child: Center(
                child:
                    Text(elt['marque'], style: ts, textAlign: TextAlign.center),
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 6,
              child: Center(
                child:
                    Text(elt['modele'], style: ts, textAlign: TextAlign.center),
              ),
            ),
            sizedbox,
          ],
        ),
      ),
    );
  }

  static AppBar createAppBar(String title, BuildContext context) {
    return AppBar(
      leadingWidth: 150,
      leading: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Image(
              image: AssetImage('assets/achicourt.png'),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            tooltip: Strings.backToolTip,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 30),
      ),
    );
  }

  static Widget createEditOption(BuildContext context, List<dynamic> tableau) {
    return SizedBox(
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 5,
        child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/routeAjout',
                arguments: tableau)),
      ),
    );
  }
}
