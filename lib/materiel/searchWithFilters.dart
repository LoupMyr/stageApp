import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:stage/class/widgets.dart';

class SearchWithFiltersPage extends StatefulWidget {
  const SearchWithFiltersPage({super.key, required this.title});

  final String title;

  @override
  State<SearchWithFiltersPage> createState() => SearchWithFiltersPageState();
}

class SearchWithFiltersPageState extends State<SearchWithFiltersPage> {
  String _dropdownvalueLieu = ' ';
  String _dropdownvalueType = ' ';
  String _dropdownvalueEtat = ' ';
  int _idLieuSelec = -1;
  int _idTypeSelec = -1;
  int _idEtatSelec = -1;
  String _anneeSelec = '';
  final Tools _tools = Tools();
  var _listM;
  var _listT;
  List<dynamic> _listElt = List.empty(growable: true);
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedDate = DateTime.now();
  Widget _col = Column(
    children: const <Widget>[
      Text(
        Strings.noSelectionStr,
        style: TextStyle(fontSize: 25),
      ),
    ],
  );

  selectYear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.selectYearTitle),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _anneeSelec = dateTime.year.toString();
                  recupMateriels();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void recupMateriels() async {
    if (await _tools.checkAdmin() == false &&
        await _tools.checkMods() == false) {
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
      _listM = _tools.sortListByDateAchat(_listM['hydra:member']);
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
    _listElt.clear();
    if (_idEtatSelec > 0) {
      search('etat', _idEtatSelec);
    }
    if (_idLieuSelec > 0) {
      search('lieuInstallation', _idLieuSelec);
    }
    if (_anneeSelec != '') {
      searchAnnee();
    }
    if (_idTypeSelec > 0) {
      search('type', _idTypeSelec);
    }
    deleteConditions();
    List<Widget> tab = List.empty(growable: true);
    if (_idTypeSelec > 0 ||
        _idEtatSelec > 0 ||
        _idLieuSelec > 0 ||
        _anneeSelec.isNotEmpty) {
      if (_listElt.isNotEmpty) {
        var type;
        for (var elt in _listElt) {
          for (var t in _listT['hydra:member']) {
            if (t['@id'] == elt['type']) {
              type = t;
            }
          }
          AssetImage img = _tools.findImg(type['libelle']);
          List<dynamic> tableau = [elt, type];
          tab.add(Widgets.createRowElt(
              elt, type, _textStyle, tableau, img, context));
          tab.add(
            Row(
              children: [
                SizedBox(
                  height: 50,
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
      } else {
        tab.add(const Text('Aucun matériel ne correspond à ces critères.'));
      }
    } else {
      tab.add(const Text('Aucune selection.'));
    }
    setState(() {
      _col = Column(
        children: tab,
      );
    });
  }

  void searchAnnee() {
    for (var elt in _listM) {
      try {
        String anneeElt =
            (DateFormat('yyyy').format(DateTime.parse(elt['dateAchat'])))
                .toString();
        if (anneeElt == _anneeSelec) {
          if (!checkIfAlreadyInList(elt['id'])) {
            _listElt.add(elt);
          }
        }
      } catch (e) {}
    }
  }

  void search(String recherche, int idSelec) {
    for (var elt in _listM) {
      List<String> temp = elt[recherche].split('/');
      int idSearch = int.parse(temp[temp.length - 1]);
      if (idSearch == idSelec) {
        if (!checkIfAlreadyInList(elt['id'])) {
          _listElt.add(elt);
        }
      }
    }
  }

  void deleteConditions() {
    List<dynamic> eltDelete = List.empty(growable: true);
    if (_listElt.isNotEmpty) {
      for (var elt in _listElt) {
        if (_idEtatSelec > 0) {
          List<String> temp = elt['etat'].split('/');
          int idSearch = int.parse(temp[temp.length - 1]);
          if (idSearch != _idEtatSelec) {
            eltDelete.add(elt);
          }
        }
        if (_idTypeSelec > 0) {
          List<String> temp = elt['type'].split('/');
          int idSearch = int.parse(temp[temp.length - 1]);
          if (idSearch != _idTypeSelec) {
            eltDelete.add(elt);
          }
        }
        if (_idLieuSelec > 0) {
          List<String> temp = elt['lieuInstallation'].split('/');
          int idSearch = int.parse(temp[temp.length - 1]);
          if (idSearch != _idLieuSelec) {
            eltDelete.add(elt);
          }
        }
        if (_anneeSelec.isNotEmpty) {
          try {
            String anneeElt =
                (DateFormat('yyyy').format(DateTime.parse(elt['dateAchat'])))
                    .toString();
            if (anneeElt != _anneeSelec) {
              eltDelete.add(elt);
            }
          } catch (e) {
            eltDelete.add(elt);
          }
        }
      }
    }
    if (eltDelete.isNotEmpty) {
      for (var elt in eltDelete) {
        _listElt.remove(elt);
      }
    }
  }

  bool checkIfAlreadyInList(var idCheck) {
    bool result = false;
    if (_listElt.isNotEmpty) {
      for (var elt in _listElt) {
        if (elt['id'] == idCheck) {
          result = true;
        }
      }
    }
    return result;
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
      appBar: Widgets.createAppBar(widget.title, context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const Text(
                'Choisissez vos filtres:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Etat: '),
                  DropdownButton(
                    value: _dropdownvalueEtat,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: Strings.itemsEtat
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _idEtatSelec = Strings.itemsEtat.indexOf(newValue!);
                      setState(() {
                        _dropdownvalueEtat = newValue;
                        recupMateriels();
                      });
                    },
                  ),
                  const Text('Type:'),
                  DropdownButton(
                    value: _dropdownvalueType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: Strings.itemsType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _idTypeSelec = Strings.itemsType.indexOf(newValue!);
                      setState(() {
                        _dropdownvalueType = newValue;
                        recupMateriels();
                      });
                    },
                  ),
                  const Text('Lieu:'),
                  DropdownButton(
                    value: _dropdownvalueLieu,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: Strings.itemsLieu
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _idLieuSelec = Strings.itemsLieu.indexOf(newValue!);
                      setState(() {
                        _dropdownvalueLieu = newValue;
                        recupMateriels();
                      });
                    },
                  ),
                  Text('Année d\'achat: '),
                  IconButton(
                    hoverColor: Colors.transparent,
                    onPressed: selectYear,
                    icon: const Icon(
                      Icons.calendar_today,
                      size: 25,
                    ),
                  ),
                  Text(_anneeSelec),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: _col,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                recupMateriels();
              }),
          tooltip: 'Actualiser',
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
