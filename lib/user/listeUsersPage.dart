import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;

import 'package:stage/widgetNonAdmin.dart';

class ListeUsersPage extends StatefulWidget {
  const ListeUsersPage({super.key, required this.title});

  final String title;

  @override
  State<ListeUsersPage> createState() => ListeUsersPageState();
}

class ListeUsersPageState extends State<ListeUsersPage> {
  var _users;
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  Future<String> recupUsers() async {
    if (await _tools.checkAdmin() == false) {
      WidgetNonAdmin.buildEmptyPopUp(context);
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
            child: Text('Email', style: _textStyleHeaders),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 3,
            child: Text('Rôle', style: _textStyleHeaders),
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
              child: Text(
                user['email'],
                style: _textStyleHeaders,
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 3,
              child: Text(role, style: _textStyleHeaders),
            ),
          ],
        ),
      );
    }
    return tab;
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
