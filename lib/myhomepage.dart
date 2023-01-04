import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/routeListe'),
                child: const Text('Consulter la liste compléte')),
            const Padding(padding: EdgeInsets.all(2)),
            ElevatedButton(
                onPressed: () => null, child: const Text('Rechercher un type')),
            const Padding(padding: EdgeInsets.all(2)),
            ElevatedButton(
                onPressed: () => null, child: const Text('Rechercher un état')),
            const Padding(padding: EdgeInsets.all(2)),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/routeAjout'),
                child: const Text('Ajouter un élément')),
          ],
        ),
      ),
    );
  }
}
