import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _topicsController = TextEditingController();

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      Provider.of<ContactProvider>(
        context,
        listen: false,
      ).addContact(name: _nameController.text, topics: _topicsController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Por favor, insira um nome.' : null,
              ),
              TextFormField(
                controller: _topicsController,
                decoration: const InputDecoration(
                  labelText: 'Tópicos-chave',
                  hintText: 'Ex: Flutter, IA, Go...',
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Por favor, insira os tópicos.' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContact,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
