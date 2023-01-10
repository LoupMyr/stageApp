import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:intl/intl.dart';

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
  String _numSerie = '';
  String _remarques = '';
  String _dateAchat = '';
  String _dateGarantie = '';
  final List<String> _itemsType = [
    ' ',
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
    'TBI',
    'Autres'
  ];
  final List<String> _itemsEtat = [
    ' ',
    'Neuf',
    'Très bon état',
    'Bon état',
    'Autres'
  ];
  String _dropdownvalueType = ' ';
  String _dropdownvalueEtat = ' ';
  bool _keep = true;
  int _idType = -1;
  int _idEtat = -1;
  Text _labelErrType = const Text('');
  Text _labelErrEtat = const Text('');

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
      var response = await _tool.postMateriel(
          _marque,
          _modele,
          _dateAchat,
          _dateGarantie,
          _remarques,
          _idType.toString(),
          _idEtat.toString(),
          _numSerie);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Matériel ajouté'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Une erreur est survenue'),
        ));
        log(response.statusCode.toString());
      }
    }
  }

  Future<void> buildEmptyPopUp(String nom) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Numéro de série'),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Saisie vide';
                      } else {
                        setState(() {
                          _numSerie = valeur;
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
                      child: const Text('Date d\'achat: ',
                          style: TextStyle(fontSize: 16.5)),
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
                      child: const Text('Date de fin de garantie: ',
                          style: TextStyle(fontSize: 16.5)),
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
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Type:', style: TextStyle(fontSize: 20)),
                    Padding(padding: EdgeInsetsDirectional.only(end: 175)),
                    Text('Etat:', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      menuMaxHeight: 300,
                      value: _dropdownvalueType,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _itemsType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _idType = _itemsType.indexOf(newValue!);
                        if (_itemsType.indexOf(newValue) == 0) {
                          setState(() {
                            _labelErrType = const Text(
                              'Veuillez choisir un type',
                              style: TextStyle(color: Colors.red),
                            );
                          });
                        }
                        setState(() {
                          _dropdownvalueType = newValue;
                        });
                      },
                    ),
                    const Padding(
                        padding: EdgeInsetsDirectional.only(end: 100)),
                    DropdownButton(
                      value: _dropdownvalueEtat,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _itemsEtat
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _idEtat = _itemsEtat.indexOf(newValue!);
                        if (_itemsEtat.indexOf(newValue) == 0) {
                          setState(() {
                            _labelErrEtat = const Text(
                              'Veuillez choisir un état',
                              style: TextStyle(color: Colors.red),
                            );
                          });
                        }
                        setState(() {
                          _dropdownvalueEtat = newValue;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _labelErrType,
                    const Padding(
                        padding: EdgeInsetsDirectional.only(end: 100)),
                    _labelErrEtat
                  ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
