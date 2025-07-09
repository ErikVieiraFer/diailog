class Contact {
  final String id;
  final String name;
  final String topics;

  Contact({required this.id, required this.name, required this.topics});

  // Método para converter um objeto Contact em um Map (para JSON)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'topics': topics};
  }

  // Método para criar um objeto Contact a partir de um Map (de JSON)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      topics: map['topics'] ?? '',
    );
  }
}
