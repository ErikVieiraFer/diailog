import 'package:flutter/material.dart';
import 'package:conecta_ia/models/contact.dart';
import 'package:conecta_ia/services/gemini_service.dart';
import 'package:conecta_ia/widgets/gradient_container.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final GeminiService _geminiService = GeminiService();
  String? _generatedQuestions;
  bool _isLoading = false;

  void _fetchQuestions() async {
    // Garante que o widget ainda está na "árvore" de widgets antes de atualizar o estado.
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _generatedQuestions = null; // Limpa perguntas antigas
    });

    final questions = await _geminiService.generateQuestions(
      widget.contact.topics,
    );

    // Garante que o widget não foi removido enquanto a chamada de rede acontecia.
    if (!mounted) return;
    setState(() {
      _generatedQuestions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.contact.name),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tópicos de Interesse:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                widget.contact.topics,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white30),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : _generatedQuestions != null
                        ? AnimatedOpacity(
                            opacity: _generatedQuestions != null ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: ListView(
                              children: [
                                Text(
                                  'Sugestões para a conversa:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _generatedQuestions!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          height: 1.5, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(), // Espaço vazio se não houver perguntas
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 16.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchQuestions,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: Text(
                      _generatedQuestions == null
                          ? 'Gerar Perguntas'
                          : 'Gerar Novamente',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}