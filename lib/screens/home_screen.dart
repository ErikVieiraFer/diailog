import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conecta_ia/widgets/gradient_container.dart';
import 'package:conecta_ia/providers/theme_provider.dart';
import 'package:conecta_ia/providers/contact_provider.dart';
import 'package:conecta_ia/screens/add_contact_screen.dart';
import 'package:conecta_ia/screens/contact_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // O conteúdo principal do Scaffold
    Widget mainContent = Scaffold(
        // A cor de fundo é transparente no modo escuro para ver o gradiente
        backgroundColor: isDarkMode ? Colors.transparent : null,
        appBar: AppBar(
          title: const Text(
            'Diailog',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.black.withOpacity(0.2) : null,
          elevation: isDarkMode ? 0 : null,
          actions: [
            IconButton(
              icon: Icon(isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            )
          ],
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
                  // O Card usará a cor e o estilo definidos no tema
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      contact.topics,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    AddContactScreen(contactToEdit: contact),
                              ),
                            );
                          },
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
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
          style: TextStyle(fontSize: 16),
        )), 
      ), 
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(
                MaterialPageRoute(builder: (ctx) => const AddContactScreen()));
          },
          
          child: const Icon(Icons.add),
        ),
    ); 

    if (isDarkMode) {
      return GradientContainer(child: mainContent);
    }

    return mainContent;
  }
}
