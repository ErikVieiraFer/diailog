import 'dart:convert';
import 'package:conecta_ia/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactService {
  static const _contactsKey = 'contacts';

  Future<void> saveContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    // Converte a lista de contatos para uma lista de Maps e depois para uma String JSON
    final contactsJson = jsonEncode(
      contacts.map((contact) => contact.toMap()).toList(),
    );
    await prefs.setString(_contactsKey, contactsJson);
  }

  Future<List<Contact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString(_contactsKey);

    if (contactsJson == null) {
      return [];
    }

    // Decodifica a String JSON para uma lista de Maps e depois para uma lista de Contatos
    final List<dynamic> contactsList = jsonDecode(contactsJson);
    return contactsList
        .map((jsonItem) => Contact.fromMap(jsonItem as Map<String, dynamic>))
        .toList();
  }
}
