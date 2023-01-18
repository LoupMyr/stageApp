import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/class/widgets.dart';

class SearchByEtat extends StatefulWidget {
  const SearchByEtat({super.key, required this.title});

  final String title;

  @override
  State<SearchByEtat> createState() => SearchByEtatState();
}

class SearchByEtatState extends State<SearchByEtat> {
  String _dropdownvalue = ' ';
  int _idSelec = -1;
  final Tools _tools = Tools();
  var _listM;
  var _listT;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _col = Column(
    children: const <Widget>[
      Text(
        Strings.noSelectionStr,
        style: TextStyle(fontSize: 25),
      ),
    ],
  );

  void recupMateriels() async {
    if (await _tools.checkAdmin() == false) {
      Widgets.buildNonAdmin(context);
      return;
    }
    _col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        SpinKitThreeInOut(color: Colors.teal),
      ],
    );
    setState(() {
      _col;
    });
    var responseM = await _tools.getMateriels();
    var responseT = await _tools.getTypes();
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _listM = convert.jsonDecode(responseM.body);
      _listT = convert.jsonDecode(responseT.body);
      buildList();
    } else {
      setState(() {
        _col = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 125,
            ),
            Text(
              '${Strings.criticalErrorStr} - ${responseM.statusCode.toString()}',
              style: const TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ],
        );
      });
    }
  }

  void buildList() {
    List<Widget> tab = [];
    if (_idSelec == 0) {
      tab.add(
        const Text(
          Strings.noSelectionStr,
          style: TextStyle(fontSize: 25),
        ),
      );
    }
    for (var elt in _listM['hydra:member']) {
      List<String> temp = elt['etat'].split('/');
      int idEtat = int.parse(temp[temp.length - 1]);
      if (idEtat == _idSelec) {
        var type;
        for (var t in _listT['hydra:member']) {
          if (t['@id'] == elt['type']) {
            type = t;
          }
        }
        AssetImage img = _tools.findImg(type['libelle']);
        List<dynamic> tableau = [elt, type];
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
                      onPressed: () => deleteElt(elt['id'].toString()),
                    )),
              ],
            ),
          ),
        );
      }
    }
    if (tab.isEmpty) {
      tab.add(Text(
        Strings.emptyEltByEtat + _dropdownvalue.toLowerCase(),
        style: const TextStyle(fontSize: 25),
      ));
    }
    setState(() {
      _col = Column(
        children: tab,
      );
    });
  }

  Future<void> deleteElt(String id) async {
    await Widgets.buildDeletePopUp(id, _listM, _scaffoldKey);
    setState(() {
      recupMateriels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 150,
        leading: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image(
                image: AssetImage('lib/assets/achicourt.png'),
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
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const Text(
                Strings.etatTitle,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              DropdownButton(
                value: _dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Strings.itemsEtat
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idSelec = Strings.itemsEtat.indexOf(newValue!);
                  setState(() {
                    _dropdownvalue = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: Widgets.createHeaders(context, _textStyleHeaders),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _col,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
