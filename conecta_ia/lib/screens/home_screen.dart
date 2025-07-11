import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conecta_ia/widgets/gradient_container.dart';
import 'package:conecta_ia/providers/contact_provider.dart';
import 'package:conecta_ia/screens/add_contact_screen.dart';
import 'package:conecta_ia/screens/contact_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'ConectAI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Consumer<ContactProvider>(
        builder: (ctx, contactProvider, child) {
          if (contactProvider.contacts.isEmpty) {
            return child!;
          }
          return ListView.builder(
            itemCount: contactProvider.contacts.length,
            itemBuilder: (ctx, i) {
              final contact = contactProvider.contacts[i];
              return Dismissible(
                key: ValueKey(contact.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: Text(
                            'Tem certeza de que deseja remover ${contact.name}?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Remover',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  // A exclusão só acontece se confirmDismiss retornar true.
                  Provider.of<ContactProvider>(context, listen: false).deleteContact(contact);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${contact.name} removido(a).')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Text(
                      contact.topics,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    AddContactScreen(contactToEdit: contact),
                              ),
                            );
                          },
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ContactDetailScreen(contact: contact),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: const Center(
            child: Text(
          'Nenhum contato adicionado ainda.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => const AddContactScreen()));
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      ),
    );
  }
}
