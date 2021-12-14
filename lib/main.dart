import 'package:ecommerce/helpers/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff7a1a1d),
  errorColor: Colors.red,
  fontFamily: 'Questrial-Regular',

);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    initialRoute: '/',
    theme: temaPadrao,
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}