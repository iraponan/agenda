import 'dart:io';

import 'package:agenda/models/contact.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editedContact;
  bool _userEdited = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _requestPop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: Text(
            _editedContact.name ?? 'Novo Contato',
            style: const TextStyle(),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey = GlobalKey<FormState>();
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img!))
                          : const AssetImage('assets/images/person.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return BottomSheet(
                        onClosing: () {},
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then((file) {
                                            if (file == null) {
                                              return;
                                            } else {
                                              setState(() {
                                                _userEdited = true;
                                                _editedContact.img = file.path;
                                              });
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.file_open,
                                          color: Colors.red,
                                          size: 50.0,
                                        ),
                                      ),
                                      const Text(
                                        'Galeria',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera)
                                              .then((file) {
                                            if (file == null) {
                                              return;
                                            } else {
                                              setState(() {
                                                _userEdited = true;
                                                _editedContact.img = file.path;
                                              });
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.camera,
                                          color: Colors.red,
                                          size: 50.0,
                                        ),
                                      ),
                                      const Text(
                                        'Câmera',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: 'Fulano Sicrano',
                          labelText: 'Nome',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _editedContact.name = text;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        controller: _nameController,
                        focusNode: _nameFocus,
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Insira seu nome!';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Divider(
                        height: 8,
                        thickness: 0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: 'seuemail@seuemail.com',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.email = text;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const Divider(
                        height: 8,
                        thickness: 0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: '(99) 99999-9999',
                          labelText: 'Telefone',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.phone = text;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
                        ],
                        controller: _phoneController,
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Informe seu Telefone!';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _editedContact.name ?? '';
      _emailController.text = _editedContact.email ?? '';
      _phoneController.text = _editedContact.phone ?? '';
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartat Alterações'),
            content:
                const Text('Se sair as alterações feitas serão descartadas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      Navigator.pop(context);
      return Future.value(true);
    }
  }
}
