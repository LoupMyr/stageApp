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
  final _formEditEmail = GlobalKey<FormState>();
  var _users;
  String _email = '';
  String _role = '';
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  Future<String> recupUsers() async {
    if (await _tools.checkAdmin() == false) {
      Widgets.buildEmptyPopUp(context);
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
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20)),
                  IconButton(
                      onPressed: () =>
                          editEmailMenu(user['id'].toString(), user['email']),
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                children: <Widget>[
                  Text(
                    role,
                    style: _textStyleHeaders,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return tab;
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children),
              ),
            ),
          );
        });
  }
}
