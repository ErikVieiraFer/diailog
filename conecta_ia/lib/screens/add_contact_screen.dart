import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conecta_ia/models/contact.dart';
import 'package:conecta_ia/providers/contact_provider.dart';
import 'package:conecta_ia/widgets/gradient_container.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? contactToEdit;

  const AddContactScreen({super.key, this.contactToEdit});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _topicsController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.contactToEdit != null) {
      _isEditing = true;
      _nameController.text = widget.contactToEdit!.name;
      _topicsController.text = widget.contactToEdit!.topics;
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ContactProvider>(context, listen: false);
      if (_isEditing) {
        provider.updateContact(
          id: widget.contactToEdit!.id,
          name: _nameController.text,
          topics: _topicsController.text,
        );
      } else {
        provider.addContact(
          name: _nameController.text,
          topics: _topicsController.text,
        );
      }
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
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Contato' : 'Adicionar Contato'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(24),
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Por favor, insira um nome.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _topicsController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Tópicos-chave',
                          hintText: 'Ex: Flutter, IA, Go...',
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Por favor, insira os tópicos.'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveContact,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: Text(_isEditing ? 'Atualizar' : 'Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
