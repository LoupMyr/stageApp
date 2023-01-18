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
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  Future<String> recupMateriels() async {
    if (await _tools.checkAdmin() == false) {
      Widgets.buildEmptyPopUp(context);
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
    List<Widget> tab = [];
    for (var elt in _materiels['hydra:member']) {
      var type;
      for (var i in _types['hydra:member']) {
        if (elt['type'] == i['@id']) {
          type = i;
        }
      }
      List<dynamic> tableau = [elt, type];
      AssetImage img = _tools.findImg(type['libelle']);
      tab.add(
        InkWell(
          onTap: () => Navigator.pushNamed(context, "/routeMateriel",
              arguments: tableau),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                  child: Text(type['libelle'], style: _textStyle),
                ),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 5,
                child: Center(
                  child: Text(elt['marque'], style: _textStyle),
                ),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 5,
                child: Center(
                  child: Text(elt['modele'], style: _textStyle),
                ),
              ),
              SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => buildDeletePopUp(elt['id'].toString()),
                  )),
            ],
          ),
        ),
      );
    }
    return Column(
      children: tab,
    );
  }

  Future<void> buildDeletePopUp(String id) async {
    return showDialog(
        context: context,
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
                onPressed: () {
                  deleteElt(id);
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

  void deleteElt(String id) async {
    for (var elt in _materiels['hydra:member']) {
      if (elt['id'].toString() == id) {
        if (elt['photos'].isNotEmpty) {
          List<int> tabIdPhoto = [];
          for (int i = 0; i < elt['photos'].length; i++) {
            List<String> temp = elt['photos'][i].split('/');
            int id = int.parse(temp[temp.length - 1]);
            tabIdPhoto.add(id);
          }
          for (int i = 0; i < tabIdPhoto.length; i++) {
            await _tools.deletePhoto(tabIdPhoto[i].toString());
          }
        }
      }
    }
    var response = await _tools.deleteMateriel(id);
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.deleteEltSuccessful),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.errorHappened),
      ));
    }
    setState(() {
      buildTab();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 5,
                      child: null,
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Text(Strings.typeHeader, style: _textStyleHeaders),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 5,
                      child:
                          Text(Strings.marqueHeader, style: _textStyleHeaders),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 5,
                      child:
                          Text(Strings.modeleHeader, style: _textStyleHeaders),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 5,
                      child:
                          Text(Strings.optionHeader, style: _textStyleHeaders),
                    ),
                  ],
                ),
                Row(
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
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.title),
              leadingWidth: 200,
              leading: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Image(
                      image: AssetImage('lib/assets/achicourt.png'),
                    ),
                  ),
                  IconButton(
                    tooltip: Strings.backToolTip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(children: children),
              ),
            ),
          );
        });
  }
}
