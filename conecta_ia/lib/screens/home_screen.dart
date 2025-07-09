import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConectAI - Contatos')),
      body: Consumer<ContactProvider>(
        builder: (ctx, contactProvider, child) {
          if (contactProvider.contacts.isEmpty) {
            return child!;
          }
          return ListView.builder(
            itemCount: contactProvider.contacts.length,
            itemBuilder:
                (ctx, i) => Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(contactProvider.contacts[i].name),
                    subtitle: Text(
                      contactProvider.contacts[i].topics,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (ctx) => ContactDetailScreen(
                                contact: contactProvider.contacts[i],
                              ),
                        ),
                      );
                    },
                  ),
                ),
          );
        },
        child: const Center(child: Text('Nenhum contato adicionado ainda.')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => const AddContactScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
