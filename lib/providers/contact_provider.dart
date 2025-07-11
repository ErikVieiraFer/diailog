import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];

  List<Contact> get contacts => [..._contacts];

  ContactProvider() {
    loadContacts();
  }

  Future<void> loadContacts() async {
    _contacts = await _contactService.getContacts();
    notifyListeners();
  }

  Future<void> addContact({required String name, required String topics}) async {
    final newContact = Contact(
      id: const Uuid().v4(),
      name: name,
      topics: topics,
    );
    _contacts.add(newContact);
    await _contactService.saveContacts(_contacts);
    notifyListeners();
  }

  Future<void> updateContact({
    required String id,
    required String name,
    required String topics,
  }) async {
    final index = _contacts.indexWhere((c) => c.id == id);
    if (index != -1) {
      // Preserva as perguntas geradas existentes ao atualizar o contato
      final existingQuestions = _contacts[index].generatedQuestions;
      final updatedContact = Contact(
        id: id,
        name: name,
        topics: topics,
        generatedQuestions: existingQuestions,
      );
      _contacts[index] = updatedContact;
      await _contactService.saveContacts(_contacts);
      notifyListeners();
    }
  }

  Future<void> deleteContact(Contact contact) async {
    _contacts.removeWhere((c) => c.id == contact.id);
    await _contactService.saveContacts(_contacts);
    notifyListeners();
  }

  /// Salva as perguntas geradas para um contato específico.
  Future<void> saveGeneratedQuestions(String contactId, String questions) async {
    final contactIndex = _contacts.indexWhere((c) => c.id == contactId);
    if (contactIndex != -1) {
      final oldContact = _contacts[contactIndex];
      // Usa o método copyWith para criar uma nova instância do contato com as perguntas atualizadas
      final updatedContact = oldContact.copyWith(generatedQuestions: questions);
      _contacts[contactIndex] = updatedContact;

      await _contactService.saveContacts(_contacts);
      notifyListeners();
    }
  }
}