import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];
  final Uuid _uuid = const Uuid();

  List<Contact> get contacts => [..._contacts];

  Future<void> loadContacts() async {
    _contacts = await _contactService.getContacts();
    notifyListeners();
  }

  Future<void> addContact({
    required String name,
    required String topics,
  }) async {
    final newContact = Contact(id: _uuid.v4(), name: name, topics: topics);
    _contacts.add(newContact);
    await _contactService.saveContacts(_contacts);
    notifyListeners();
  }

  Future<void> deleteContact(Contact contact) async {
    _contacts.remove(contact);
    await _contactService.saveContacts(_contacts);
    notifyListeners();
  }

  Future<void> updateContact({
    required String id,
    required String name,
    required String topics,
  }) async {
    final contactIndex = _contacts.indexWhere((c) => c.id == id);
    if (contactIndex >= 0) {
      _contacts[contactIndex] = Contact(id: id, name: name, topics: topics);
      await _contactService.saveContacts(_contacts);
      notifyListeners();
    }
  }
}
