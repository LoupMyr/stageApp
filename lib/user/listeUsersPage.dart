import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;
import 'package:stage/class/widgets.dart';

class ListeUsersPage extends StatefulWidget {
  const ListeUsersPage({super.key, required this.title});

  final String title;

  @override
  State<ListeUsersPage> createState() => ListeUsersPageState();
}

class ListeUsersPageState extends State<ListeUsersPage> {
  final _formEditEmail = new GlobalKey<FormState>();
  final _formEditRole = new GlobalKey<FormState>();
  var _users;
  String _email = '';
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  bool _isCheckedMod = false;
  bool _isCheckedAdmin = false;

  Future<String> recupUsers() async {
    if (await _tools.checkAdmin() == false) {
      Widgets.buildNonAdmin(context);
      return '';
    }
    var response = await _tools.getUsers();
    if (response.statusCode == 200) {
      _recupDataBool = true;
      _users = convert.jsonDecode(response.body);
    } else {
      log(response.statusCode.toString());
    }
    return '';
  }

  List<Widget> createList() {
    List<Widget> tab = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 3,
            child: Text(Strings.emailLabel, style: _textStyleHeaders),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 3,
            child: Text(Strings.roleLabel, style: _textStyleHeaders),
          ),
        ],
      ),
    ];
    for (var user in _users['hydra:member']) {
      List<String> temp = user['roles'][0].split('_');
      String role = temp[1].toLowerCase();
      tab.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                children: <Widget>[
                  Text(
                    user['email'],
                    style: _textStyleHeaders,
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20)),
                  IconButton(
                      onPressed: () =>
                          editEmailMenu(user['id'].toString(), user['email']),
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 50)),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                children: <Widget>[
                  Text(role,
                      style: _textStyleHeaders, textAlign: TextAlign.center),
                  const Padding(padding: EdgeInsets.only(right: 20)),
                  IconButton(
                      onPressed: () =>
                          editRoleMenu(user['id'].toString(), role),
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ),
      );
    }
    return tab;
  }

  void refreshPerm(String role) {
    _isCheckedAdmin = false;
    _isCheckedMod = false;
    if (role == 'admin') {
      _isCheckedAdmin = true;
      _isCheckedMod = true;
    } else if (role == 'moderator') {
      _isCheckedMod = true;
    }
  }

  Future<String?> editRoleMenu(String id, String role) {
    refreshPerm(role);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(Strings.editEmailTitle),
        content: SizedBox(
          width: 200,
          height: 500,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formEditRole,
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Voir tous les matériels'),
                      value: _isCheckedMod,
                      onChanged: (bool? value) {
                        if (!value!) {
                          _isCheckedAdmin = value;
                        }
                        setState(() {
                          _isCheckedMod = value;
                        });
                      },
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    CheckboxListTile(
                      title: const Text(
                          'Ajouter, supprimer et modifé des matériels'),
                      value: _isCheckedAdmin,
                      onChanged: (bool? value) {
                        if (value!) {
                          _isCheckedMod = value;
                        }
                        setState(() {
                          _isCheckedMod;
                          _isCheckedAdmin = value;
                        });
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Annuler'),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        ElevatedButton(
                          onPressed: () {
                            if (_formEditRole.currentState!.validate()) {
                              editRole(id);
                            }
                          },
                          child: const Text('Modifier'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String?> editEmailMenu(String id, String email) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(Strings.editEmailTitle),
        content: Form(
          key: _formEditEmail,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFormField(
                  initialValue: email,
                  decoration:
                      const InputDecoration(labelText: Strings.emailLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.emptyInputStr;
                    } else {
                      _email = value.toString();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formEditEmail.currentState!.validate()) {
                      editEmail(id);
                    }
                  },
                  child: const Text(Strings.validButtonStr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editEmail(String id) async {
    var response = await _tools.patchUserEmail(id, _email);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.editEmailSuccessful),
      ));
      setState(() {
        recupUsers();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${Strings.errorStr} ${response.statusCode}'),
      ));
    }
  }

  Future<void> editRole(String id) async {
    String role = _tools.guessRole(_isCheckedAdmin, _isCheckedMod);
    var response = await _tools.patchUserRole(id, role);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Rôle modifié'),
      ));
      setState(() {
        recupUsers();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${Strings.errorStr} ${response.statusCode}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupUsers(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupDataBool) {
              children = createList();
            } else {
              recupUsers();
              children = <Widget>[];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[];
          } else {
            children = <Widget>[
              const SpinKitThreeInOut(
                color: Colors.teal,
                size: 100,
              ),
            ];
          }
          return Scaffold(
            appBar: Widgets.createAppBar(widget.title, context),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children),
              ),
            ),
          );
        });
  }
}
