import 'package:flutter/material.dart';
import 'package:stage/class/local.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key, required this.title});

  final String title;

  @override
  State<ConnexionPage> createState() => ConnexionPageState();
}

class ConnexionPageState extends State<ConnexionPage> {
  final Tools _tools = Tools();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _mdp = '';

  void connect() async {
    var response = await _tools.authenticationUser(_email, _mdp);
    if (response.statusCode == 200) {
      var token = convert.jsonDecode(response.body);
      await Local.storage.write(key: 'token', value: token['token']);
      await Local.storage.write(key: 'email', value: _email);
      await Local.storage.write(key: 'password', value: _mdp);
      await Local.storage.write(key: 'role', value: token['data']['roles'][0]);
      await Local.storage
          .write(key: 'id', value: token['data']['id'].toString());
      Navigator.pushReplacementNamed(context, '/routeHome');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bienvenue !'),
      ));
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Identifiants incorrects'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur ${response.statusCode.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
              tooltip: 'Inscription',
              padding: const EdgeInsets.only(right: 30),
              iconSize: 30,
              icon: const Icon(Icons.person_add),
              onPressed: () =>
                  Navigator.pushNamed(context, '/routeInscription')),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(100.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return 'Saisie vide';
                          } else {
                            setState(() {
                              _email = valeur;
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Mot de passe'),
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return 'Saisie vide';
                          } else {
                            setState(() {
                              _mdp = valeur;
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(40)),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          connect();
                        }
                      },
                      child: const Text("Valider"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
