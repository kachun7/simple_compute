import 'package:flutter/material.dart';

import 'app.dart';
import 'service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MyService service = MyService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BodyWidget(service: service),
      ),
    );
  }
}
