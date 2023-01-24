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
  AjoutPage({super.key, required this.title});
  String title;

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
  String _remarques = '';
  String _dateAchat = '';
  String _dateGarantie = '';
  String _detailsAutre = '';
  String _dropdownvalueType = ' ';
  String _dropdownvalueEtat = ' ';
  String _dropdownvalueLieu = ' ';
  bool _keep = true;
  int _idType = -1;
  int _idEtat = -1;
  int _idLieu = -1;
  Text _labelErrType = const Text('');
  Text _labelErrLieu = const Text('');
  Text _labelErrEtat = const Text('');
  final List<String> _listUrl = List.empty(growable: true);
  final fieldImages = TextEditingController();
  final fieldMarque = TextEditingController();
  final fieldModele = TextEditingController();
  final fieldNumSerie = TextEditingController();
  final fieldNumInventaire = TextEditingController();
  final fieldLieuInstallation = TextEditingController();
  final fieldRemarques = TextEditingController();
  final fieldDetailsAutres = TextEditingController();
  bool _estEdit = false;
  bool _hasRecup = false;
  String _idMateriel = '-1';
  List<dynamic> _tabArg = List.empty(growable: true);

  void clearUrl() {
    fieldImages.clear();
  }

  void clearTexts() {
    fieldMarque.clear();
    fieldModele.clear();
    fieldNumSerie.clear();
    fieldNumInventaire.clear();
    fieldLieuInstallation.clear();
    fieldRemarques.clear();
    fieldDetailsAutres.clear();
    _dropdownvalueType = ' ';
    _dropdownvalueEtat = ' ';
    _dropdownvalueLieu = ' ';
    _dateAchat = '';
    _dateGarantie = '';
    _idLieu = 0;
    _idType = 0;
    _idEtat = 0;
    clearUrl();
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
          _idLieu.toString(),
          _detailsAutre);
      if (response.statusCode == 201) {
        var materiel = convert.jsonDecode(response.body);
        clearTexts();
        if (_listUrl.isNotEmpty) {
          String uriMateriel =
              '/stageAppWeb/public/api/materiels/${materiel['id']}';
          List<String> tabUriPhotos = List.empty(growable: true);
          for (int i = 0; i < _listUrl.length; i++) {
            var post = await _tool.postPhoto(_listUrl[i], uriMateriel);

            if (post.statusCode == 201) {
              var postTemp = convert.jsonDecode(post.body);
              tabUriPhotos
                  .add('/stageAppWeb/public/api/photos/${postTemp['id']}');
            }
          }
          await _tool.patchMaterielPhoto(
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

  void sendPatchRequest(String idMateriel) async {
    if (await _tool.checkAdmin() == false) {
      Widgets.buildNonAdmin(context);
      return;
    }
    if (_idLieu != Strings.itemsLieu.length - 1) {
      _detailsAutre = '';
    }
    var response = await _tool.patchMateriel(
        idMateriel,
        _marque,
        _modele,
        _dateAchat,
        _dateGarantie,
        _remarques,
        _idType.toString(),
        _idEtat.toString(),
        _numSerie,
        _numInventaire,
        _idLieu.toString(),
        _detailsAutre);
    if (response.statusCode == 200) {
      var materiel = convert.jsonDecode(response.body);
      clearTexts();
      if (_listUrl.isNotEmpty) {
        String uriMateriel =
            '/stageAppWeb/public/api/materiels/${materiel['id']}';
        List<String> tabUriPhotos = List.empty(growable: true);
        for (int i = 0; i < _listUrl.length; i++) {
          var post = await _tool.postPhoto(_listUrl[i], uriMateriel);

          if (post.statusCode == 201) {
            var postTemp = convert.jsonDecode(post.body);
            tabUriPhotos
                .add('/stageAppWeb/public/api/photos/${postTemp['id']}');
          }
        }
        await _tool.patchMaterielPhoto(tabUriPhotos, materiel['id'].toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.materialEdited),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.errorHappened),
      ));
      log(response.statusCode.toString());
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

  SizedBox createFieldDetails() {
    SizedBox sizedbox = const SizedBox();
    if (_idLieu == Strings.itemsLieu.length - 1) {
      sizedbox = SizedBox(
        width: MediaQuery.of(context).size.width * 0.18,
        child: TextFormField(
          controller: fieldDetailsAutres,
          decoration:
              const InputDecoration(labelText: Strings.detailsLieuAutresLabel),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return Strings.emptyInputStr;
            } else {
              setState(() {
                _detailsAutre = valeur;
              });
            }
          },
        ),
      );
    }
    return sizedbox;
  }

  void fillFields() {
    widget.title = 'Modification';
    fieldMarque.value = TextEditingValue(text: _tabArg[0]['marque']);
    fieldModele.value = TextEditingValue(text: _tabArg[0]['modele']);
    fieldNumInventaire.value =
        TextEditingValue(text: _tabArg[0]['numInventaire']);
    fieldNumSerie.value = TextEditingValue(text: _tabArg[0]['numSerie']);
    _idEtat = _tool.splitUri(_tabArg[0]['etat']);
    _idType = _tool.splitUri(_tabArg[0]['type']);
    _idLieu = _tool.splitUri(_tabArg[0]['lieuInstallation']);
    _dropdownvalueType = Strings.itemsType[_idType];
    _dropdownvalueEtat = Strings.itemsEtat[_idEtat];
    _dropdownvalueLieu = Strings.itemsLieu[_idLieu];
    createFieldDetails();
    try {
      fieldDetailsAutres.value =
          TextEditingValue(text: _tabArg[0]['detailTypeAutres']);
    } catch (e) {}
    try {
      fieldRemarques.value = TextEditingValue(text: _tabArg[0]['remarques']);
    } catch (e) {}
    try {
      _dateAchat = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(_tabArg[0]['dateAchat']))
          .toString();
    } catch (e) {}
    try {
      setState(() {
        _dateGarantie = DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(_tabArg[0]['dateFinGaranti']))
            .toString();
      });
    } catch (e) {}
    _idMateriel = _tabArg[0]['id'].toString();
    _hasRecup = true;
  }

  @override
  Widget build(BuildContext context) {
    _tabArg = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    if (_tabArg.isNotEmpty && !_hasRecup) {
      _estEdit = true;
      fillFields();
    }
    return Scaffold(
      appBar: Widgets.createAppBar(widget.title, context),
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
                    controller: fieldMarque,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.marqueLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return Strings.emptyInputStr;
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
                    controller: fieldModele,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.modeleLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return Strings.emptyInputStr;
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
                    controller: fieldNumSerie,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    decoration:
                        const InputDecoration(labelText: Strings.numSerieLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return Strings.emptyInputStr;
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
                    controller: fieldNumInventaire,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                      NumInventaireInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                        labelText: Strings.numInventaireLabel),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return Strings.emptyInputStr;
                      } else {
                        setState(() {
                          _numInventaire = valeur;
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
                    controller: fieldRemarques,
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
                    Padding(padding: EdgeInsetsDirectional.only(end: 175)),
                    Text(Strings.lieuLabel, style: TextStyle(fontSize: 20)),
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
                      items: Strings.itemsType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _idType = Strings.itemsType.indexOf(newValue!);
                        if (Strings.itemsType.indexOf(newValue) == 0) {
                          setState(() {
                            _labelErrType = const Text(
                              Strings.errorTypeLabel,
                              style: TextStyle(color: Colors.red),
                            );
                          });
                        } else {
                          setState(() {
                            _labelErrType = const Text('');
                          });
                        }
                        setState(() {
                          _dropdownvalueType = newValue;
                        });
                      },
                    ),
                    const Padding(padding: EdgeInsetsDirectional.only(end: 50)),
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
                        _idEtat = Strings.itemsEtat.indexOf(newValue!);
                        if (Strings.itemsEtat.indexOf(newValue) == 0) {
                          setState(() {
                            _labelErrEtat = const Text(
                              Strings.errorEtatLabel,
                              style: TextStyle(color: Colors.red),
                            );
                          });
                        } else {
                          setState(() {
                            _labelErrEtat = const Text('');
                          });
                        }
                        setState(() {
                          _dropdownvalueEtat = newValue;
                        });
                      },
                    ),
                    const Padding(padding: EdgeInsetsDirectional.only(end: 50)),
                    DropdownButton(
                      menuMaxHeight: 300,
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
                        _idLieu = Strings.itemsLieu.indexOf(newValue!);
                        if (Strings.itemsLieu.indexOf(newValue) == 0) {
                          setState(() {
                            _labelErrLieu = const Text(
                              Strings.errorLieuLabel,
                              style: TextStyle(color: Colors.red),
                            );
                          });
                        } else {
                          setState(() {
                            _labelErrLieu = const Text('');
                          });
                        }
                        setState(() {
                          _dropdownvalueLieu = newValue;
                        });
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    createFieldDetails(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(padding: EdgeInsetsDirectional.only(top: 10)),
                    _labelErrType,
                    _labelErrEtat,
                    _labelErrLieu,
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
                        controller: fieldImages,
                        decoration: const InputDecoration(
                            labelText: Strings.uploadImgLabel),
                        onFieldSubmitted: (valeur) {
                          if (valeur.isEmpty) {
                            return;
                          } else {
                            setState(() {
                              _listUrl.add(valeur);
                              clearUrl();
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
                      if (_estEdit) {
                        sendPatchRequest(_idMateriel);
                      } else {
                        sendRequest();
                      }
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
