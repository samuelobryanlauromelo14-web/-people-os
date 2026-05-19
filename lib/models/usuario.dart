// lib/models/usuario.dart

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String site;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.site,
  });

  /// API → objeto Dart
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['name'] as String,
      email: json['email'] as String,
      telefone: json['phone'] as String? ?? '',
      site: json['website'] as String? ?? '',
    );
  }

  /// objeto Dart → API
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nome,
        'email': email,
        'phone': telefone,
        'website': site,
      };

  /// Cria uma cópia com campos alterados
  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? site,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      site: site ?? this.site,
    );
  }

  /// Iniciais para o avatar
  String get iniciais {
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    if (partes[0].isNotEmpty) return partes[0][0].toUpperCase();
    return '?';
  }
}
