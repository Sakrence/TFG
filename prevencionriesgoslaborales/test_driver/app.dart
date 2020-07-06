import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
// import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/main.dart' as app;
// import 'package:prevencionriesgoslaborales/src/pages/home.dart' as app;

void main() {
  enableFlutterDriverExtension();
  
  app.main();

  // runApp(
  //   Provider(
  //     child: MaterialApp(
  //       home: app.HomePage(),
  //     ),
  //   ),
  // );

}
