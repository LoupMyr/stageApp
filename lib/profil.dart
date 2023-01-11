import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, required this.title});

  final String title;

  @override
  State<ProfilPage> createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  var _user;
  Tools _tools = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  Future<String> recupUser() async {
    _recupDataBool = false;
    var response = await _tools.getUser();
    if (response.statusCode == 200) {
      _recupDataBool = true;
      _user = convert.jsonDecode(response.body);
      print(_user);
    } else {
      log(response.statusCode.toString());
    }
    return '';
  }

  List<Widget> createList() {
    List<Widget> tab = [];
    List<String> temp = _user['roles'][0].split('_');
    String role = temp[1].toLowerCase();
    tab.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              _user['email'],
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
    return tab;
  }

  String formatRole() {
    List<String> temp = _user['roles'][0].split('_');
    String role = temp[1].toLowerCase();
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupUser(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupDataBool) {
              children = [
                const Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0), width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 500,
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Voici vos infomatations:',
                        style: TextStyle(
                            fontSize: 23, decoration: TextDecoration.underline),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 40)),
                      Row(
                        children: <Widget>[
                          const Text('Email: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.underline)),
                          // SizedBox(
                          //     width: MediaQuery.of(context).size.width * 0.05),
                          Text(_user['email'],
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Role: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.underline)),
                          // SizedBox(
                          //     width: MediaQuery.of(context).size.width * 0.058),
                          Text(formatRole(),
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            } else {
              recupUser();
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
