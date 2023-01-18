import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stage/class/numInventaireFormatter.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'package:intl/intl.dart';
import 'package:stage/class/widgets.dart';
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
  String _numSerie = '';
  String _numInventaire = '';
  String _lieuInstallation = '';
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
  List<String> _listUrl = [];
  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  void sendRequest() async {
    if (await _tool.checkAdmin() == false) {
      Widgets.buildNonAdmin(context);
      return;
    }
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

    if (_listUrl.isEmpty && _keep) {
      await buildEmptyPopUp('photos');
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
          _numSerie,
          _numInventaire,
          _lieuInstallation);
      if (response.statusCode == 201) {
        var materiel = convert.jsonDecode(response.body);

        String uriMateriel =
            '/stageAppWeb/public/api/materiels/${materiel['id']}';
        List<String> tabUriPhotos = List.empty(growable: true);
        if (_listUrl.isNotEmpty) {
          for (int i = 0; i < _listUrl.length; i++) {
            var post = await _tool.postPhoto(_listUrl[i], uriMateriel);

            if (post.statusCode == 201) {
              var postTemp = convert.jsonDecode(post.body);
              tabUriPhotos
                  .add('/stageAppWeb/public/api/photos/${postTemp['id']}');
            }
          }
          var reponse = await _tool.patchMaterielPhoto(
              tabUriPhotos, materiel['id'].toString());
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(Strings.materialAdded),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(Strings.errorHappened),
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
            title: const Text(Strings.emptyField),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(Strings.fieldEmpty1 + nom + Strings.fieldEmpty2),
                  const Text(Strings.keepSaving),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(Strings.yesButtonStr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(Strings.cancelButtonStr),
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.marqueLabel),
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.modeleLabel),
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.numSerieLabel),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                      NumInventaireInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                        labelText: Strings.numInventaireLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Saisie vide';
                      } else {
                        setState(() {
                          _numInventaire = valeur;
                        });
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration: const InputDecoration(
                        labelText: Strings.lieuInstallationLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Saisie vide';
                      } else {
                        setState(() {
                          _lieuInstallation = valeur;
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
                      child: const Text(Strings.dateAchatLabel,
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
                      child: const Text(Strings.dateGarantieLabel,
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
                    decoration:
                        const InputDecoration(hintText: Strings.remarquesLabel),
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
                    Text(Strings.typeLabel, style: TextStyle(fontSize: 20)),
                    Padding(padding: EdgeInsetsDirectional.only(end: 175)),
                    Text(Strings.etatLabel, style: TextStyle(fontSize: 20)),
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
                              Strings.errorTypeLabel,
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
                              Strings.errorEtatLabel,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(Strings.uploadImgStr),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        controller: fieldText,
                        decoration: const InputDecoration(
                            labelText: Strings.uploadImgLabel),
                        onFieldSubmitted: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return;
                          } else {
                            setState(() {
                              _listUrl.add(valeur);
                              clearText();
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 30)),
                    Column(
                      children: <Widget>[
                        ...List.generate(_listUrl.length, (index) {
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    width: 2),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(Icons.check_circle_rounded,
                                            color: Colors.green),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5)),
                                        Text(
                                          _listUrl[index],
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5)),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          onPressed: () {
                                            _listUrl.removeAt(index);
                                            setState(() {
                                              _listUrl;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
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
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
