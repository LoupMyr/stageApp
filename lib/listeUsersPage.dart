import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;

class ListeUsersPage extends StatefulWidget {
  const ListeUsersPage({super.key, required this.title});

  final String title;

  @override
  State<ListeUsersPage> createState() => ListeUsersPageState();
}

class ListeUsersPageState extends State<ListeUsersPage> {
  var _users;
  Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  Future<String> recupUsers() async {
    var response = await _tools.getUsers();
    print(response.statusCode);
    if (response.statusCode == 200) {
      _recupDataBool = true;
      _users = convert.jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
    return '';
  }

  Widget createList() {
    List<Widget> tab = [];
    for (var user in _users['hydra:member']) {
      print(user);
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 3,
          child: Text(user['email'], style: _textStyleHeaders),
        ),
      );
      List<String> temp = user['roles'][0].split('_');
      String role = temp[1].toLowerCase();
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 3,
          child: Text(role, style: _textStyleHeaders),
        ),
      );
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tab);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupUsers(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupDataBool) {
              children = <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text('Email', style: _textStyleHeaders),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text('Rôle', style: _textStyleHeaders),
                    ),
                  ],
                ),
                createList(),
              ];
            } else {
              recupUsers();
              children = <Widget>[];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[];
          } else {
            children = <Widget>[
              const SpinKitRipple(
                color: Colors.teal,
                size: 100,
              )
            ];
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.title),
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
