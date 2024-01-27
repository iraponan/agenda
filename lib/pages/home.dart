import 'package:agenda/models/contact.dart';
import 'package:agenda/repositories/contacts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Contacts contacts = Contacts();


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
