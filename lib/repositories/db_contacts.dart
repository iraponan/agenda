import 'package:agenda/config/init_db.dart';
import 'package:agenda/models/contact.dart';
import 'package:agenda/models/db/contactTable.dart';
import 'package:sqflite/sqflite.dart';

class DbContacts {
  static final DbContacts _instance = DbContacts.internal();

  factory DbContacts() => _instance;

  DbContacts.internal();

  Future<Contact> saveContatc(Contact contact) async {
    Database dbContact = await InitDb.db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database dbContact = await InitDb.db;
    List<Map<String, dynamic>> maps = await dbContact.query(contactTable,
        columns: [
          idColumn,
          nameColumn,
          emailColumn,
          phoneColumn,
          imgColumn,
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContatc(int id) async {
    Database dbContact = await InitDb.db;
    return await dbContact.delete(
      contactTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateContatc(Contact contact) async {
    Database dbContact = await InitDb.db;
    return await dbContact.update(
      contactTable,
      contact.toMap(),
      where: '$idColumn = ?',
      whereArgs: [contact.id],
    );
  }

  Future<List<Contact>> getAllContatcs() async {
    Database dbContact = await InitDb.db;
    List<Map<String, dynamic>> listMap = await dbContact.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContact = <Contact>[];
    for (Map<String, dynamic> map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }
  
  Future<int?> getNumber() async {
    Database dbContact = await InitDb.db;
    return Sqflite.firstIntValue(await dbContact.rawQuery('SELECT COUNT(1) FROM $contactTable'));
  }

  Future<void> close() async {
    Database dbContact = await InitDb.db;
    dbContact.close();
  }
}
