import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import '../providers/theme_provider.dart';
import '../services/gemini_service.dart';
import '../widgets/gradient_container.dart';

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

  @override
  void initState() {
    super.initState();
    // Se as perguntas já estiverem salvas no contato, exibe-as imediatamente.
    if (widget.contact.generatedQuestions != null &&
        widget.contact.generatedQuestions!.isNotEmpty) {
      _generatedQuestions = widget.contact.generatedQuestions;
    }
  }
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

    // Verifica se a resposta é válida e não uma mensagem de erro antes de salvar.
    final isError = questions == null ||
        questions.startsWith('Erro:') ||
        questions.startsWith('Desculpe,');

    if (!isError) {
      Provider.of<ContactProvider>(context, listen: false)
          .saveGeneratedQuestions(widget.contact.id, questions);
    }
    setState(() {
      _generatedQuestions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    Widget mainContent = Scaffold(
        backgroundColor: isDarkMode ? Colors.transparent : null,
        appBar: AppBar(
          title: Text(widget.contact.name),
          backgroundColor: isDarkMode ? Colors.transparent : null,
          elevation: isDarkMode ? 0 : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tópicos de Interesse:',
                style: Theme.of(context)
                    .textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                widget.contact.topics,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    // Animação de fade e um leve slide de baixo para cima
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildAnimatedContent(),
                ),
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
                    // O estilo virá do tema
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    if (isDarkMode) {
      return GradientContainer(child: mainContent);
    }
    return mainContent;
  }

  /// Constrói o conteúdo a ser exibido dentro do AnimatedSwitcher.
  Widget _buildAnimatedContent() {
    // A key é crucial para o AnimatedSwitcher saber que o widget mudou.
    if (_isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

    if (_generatedQuestions != null) {
      return _buildQuestionsView(context, key: const ValueKey('questions'));
    }

    // Estado inicial ou quando não há nada para mostrar.
    return Container(key: const ValueKey('empty'));
  }

  /// Constrói a visualização para as perguntas geradas ou para a mensagem de erro.
  Widget _buildQuestionsView(BuildContext context, {Key? key}) {
    final isError = _generatedQuestions!.startsWith('Erro:') ||
        _generatedQuestions!.startsWith('Desculpe,');

    return isError
        ? Center(
            key: key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _generatedQuestions!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          )
        : ListView(
            key: key,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sugestões para a conversa:',
                      style: Theme.of(context)
                          .textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_all_outlined),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _generatedQuestions!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perguntas copiadas!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  _generatedQuestions!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge?.copyWith(height: 1.5),
                ),
              ],
          );
  }
}