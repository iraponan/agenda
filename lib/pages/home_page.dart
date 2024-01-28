import 'dart:io';

import 'package:agenda/models/contact.dart';
import 'package:agenda/pages/contact_page.dart';
import 'package:agenda/repositories/db_contacts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbContacts dbContacts = DbContacts();
  List<Contact> contacts = <Contact>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img!))
                        : const AssetImage('assets/images/person.png')
                            as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? '',
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? '',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    dbContacts.getAllContatcs().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
        settings: const RouteSettings(name: '/contact_page'),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await dbContacts.updateContatc(recContact);
      } else {
        await dbContacts.saveContatc(recContact);
      }
      _getAllContacts();
    }
  }
}
