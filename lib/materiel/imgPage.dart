import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'package:stage/class/widgets.dart';

class ImgPage extends StatefulWidget {
  const ImgPage({super.key, required this.title});

  final String title;

  @override
  State<ImgPage> createState() => ImgPageState();
}

class ImgPageState extends State<ImgPage> {
  String _urlImg = '';

  @override
  Widget build(BuildContext context) {
    _urlImg = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: Widgets.createAppBar(widget.title, context),
      body: SingleChildScrollView(
        child: Center(
          child: Image(
            image: NetworkImage(_urlImg),
          ),
        ),
      ),
    );
  }
}
