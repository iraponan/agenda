import 'package:agenda/pages/contact_page.dart';
import 'package:agenda/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    initialRoute: '/home',
    routes: <String, WidgetBuilder> {
      '/home' : (BuildContext context) => const HomePage(),
      '/contact_page' : (BuildContext context) => const ContactPage(),
    },
  ));
}