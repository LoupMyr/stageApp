import 'package:flutter/material.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;
import 'package:stage/class/widgets.dart';

class ListePage extends StatefulWidget {
  const ListePage({super.key, required this.title});

  final String title;

  @override
  State<ListePage> createState() => ListePageState();
}

class ListePageState extends State<ListePage> {
  var _materiels;
  var _types;
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> recupMateriels() async {
    if (await _tools.checkAdmin() == false &&
        await _tools.checkMods() == false) {
      Widgets.buildNonAdmin(context);
      return '';
    }
    var responseM = await _tools.getMateriels();
    var responseT = await _tools.getTypes();
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _materiels = convert.jsonDecode(responseM.body);
      _types = convert.jsonDecode(responseT.body);
      _recupDataBool = true;
    }
    return '';
  }

  Widget buildTab() {
    List<Widget> tab = List.empty(growable: true);
    for (var elt in _materiels['hydra:member'].reversed) {
      var type;
      for (var i in _types['hydra:member']) {
        if (elt['type'] == i['@id']) {
          type = i;
        }
      }
      List<dynamic> tableau = [elt, type];
      AssetImage img = _tools.findImg(type['libelle']);
      tab.add(Widgets.createRowElt(
          elt, type, _textStyleHeaders, tableau, img, context));
      tab.add(
        Row(
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 5,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteElt(elt['id'].toString()),
              ),
            ),
            Widgets.createEditOption(context, tableau),
          ],
        ),
      );
    }
    return Column(
      children: tab,
    );
  }

  Future<void> deleteElt(String id) async {
    await Widgets.buildDeletePopUp(id, _materiels, _scaffoldKey);
    setState(() {
      recupMateriels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupMateriels(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupDataBool) {
              children = <Widget>[
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: Widgets.createHeaders(context),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildTab(),
                  ],
                ),
              ];
            } else {
              recupMateriels();
              children = <Widget>[
                const SpinKitThreeInOut(
                  color: Colors.teal,
                  size: 100,
                )
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 125,
              ),
              const Text(
                Strings.criticalErrorStr,
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              const SpinKitThreeInOut(
                color: Colors.teal,
                size: 100,
              ),
            ];
          }
          return Scaffold(
            key: _scaffoldKey,
            appBar: Widgets.createAppBar(widget.title, context),
            body: SingleChildScrollView(
              child: Center(
                child: Column(children: children),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () => setState(() {
                      recupMateriels();
                    }),
                tooltip: 'Actualiser',
                child: const Icon(Icons.refresh_outlined)),
          );
        });
  }
}
