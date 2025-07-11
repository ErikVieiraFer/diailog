class Contact {
  final String id;
  final String name;
  final String topics;
  final String? generatedQuestions;

  Contact({
    required this.id,
    required this.name,
    required this.topics,
    this.generatedQuestions,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? topics,
    String? generatedQuestions,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      topics: topics ?? this.topics,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
    );
  }

  // Método para converter um objeto Contact em um Map (para JSON)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'topics': topics, 'generatedQuestions': generatedQuestions};
  }

  // Método para criar um objeto Contact a partir de um Map (de JSON)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      topics: map['topics'] ?? '',
      generatedQuestions: map['generatedQuestions'],
    );
  }
}
