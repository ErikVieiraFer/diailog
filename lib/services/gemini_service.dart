import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Usa a variável de ambiente para a chave da API
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  Future<String?> generateQuestions(String topics) async {
    if (_apiKey.isEmpty) {
      return 'Erro: Chave da API do Gemini não configurada.';
    }

    // Usando um modelo mais recente e recomendado.
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );

    final prompt =
        'Gere 3 perguntas criativas e abertas para iniciar uma conversa com alguém que se interessa por "$topics". As perguntas devem ser inteligentes, em português do Brasil, e evitar o óbvio. Formate a resposta como uma lista numerada (1., 2., 3.).';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text;
    } catch (e) {
      print('Erro ao gerar conteúdo: $e');
      // Retorna uma mensagem mais detalhada para facilitar a depuração na UI.
      return 'Desculpe, não foi possível gerar as perguntas no momento.\n\nErro técnico: $e';
    }
  }
}
