import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/tools.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

class AjoutPage extends StatefulWidget {
  const AjoutPage({super.key, required this.title});
  final String title;

  @override
  State<AjoutPage> createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  final Tools _tool = Tools();
  final _formKey = GlobalKey<FormState>();
  String _marque = '';
  String _modele = '';
  String _remarques = '';
  String _dateAchat = '';
  String _dateGarantie = '';
  var items = [
    'Unité centrale',
    'Ecran',
    'Clavier',
    'Souris',
    'Imprimante',
    'Copieur',
    'NAS',
    'Serveur',
    'Switch',
    'Point accès wifi',
    'ENI',
    'TBI'
  ];
  String dropdownvalue = '';
  bool _keep = true;
  int idType = -1;

  void sendRequest() async {
    _keep = true;
    if (_dateAchat.isEmpty && _keep) {
      await buildEmptyPopUp('date d\'achat');
    }
    if (_dateGarantie.isEmpty && _keep) {
      await buildEmptyPopUp('date de fin de la garantie');
    }
    if (_remarques.isEmpty && _keep) {
      await buildEmptyPopUp('remarques');
    }
    if (_keep) {
      var response = await _tool.postMateriel(_marque, _modele, _dateAchat,
          _dateGarantie, _remarques, idType.toString());
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Matériel ajouté'),
        ));
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<String> recupType() async {
    var response = await _tool.getTypes();
    if (response.statusCode == 200) {
      var temp = convert.jsonDecode(response.body);
      dropdownvalue = items[1];
    }
    return '';
  }

  Future<void> buildEmptyPopUp(String nom) async {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Champ vide'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Le champ "$nom" est vide.'),
                  const Text(
                      'Etes vous sûr de vouloir enregistrer tout de même ?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  _keep = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupType(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Marque'),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Saisie vide';
                    } else {
                      setState(() {
                        _marque = valeur;
                      });
                    }
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Modèle'),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Saisie vide';
                    } else {
                      setState(() {
                        _modele = valeur;
                      });
                    }
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: const Text('Date d\'achat: '),
                  ),
                  IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            _dateAchat = formattedDate;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    children: <Widget>[
                      Text(_dateAchat),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: const Text('Date de fin de garanti: '),
                  ),
                  IconButton(
                    hoverColor: Colors.transparent,
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          _dateGarantie = formattedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                  Row(
                    children: <Widget>[
                      Text(_dateGarantie),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: 'Remarques'),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      _remarques = '';
                    } else {
                      _remarques = valeur;
                    }
                  },
                ),
              ),
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  idType = items.indexOf(newValue!) + 1;
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendRequest();
                  }
                },
                child: const Text("Valider"),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
              )
            ];
          } else {
            children = <Widget>[
              const SpinKitPulse(
                color: Colors.teal,
                size: 100,
              )
            ];
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
