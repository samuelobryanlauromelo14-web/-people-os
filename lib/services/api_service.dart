// lib/services/api_service.dart
//
// Única camada que conhece URLs, headers e status codes.
// As telas nunca tocam em http diretamente.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Map<String, String> _jsonHeader = {
    'Content-Type': 'application/json',
  };

  // ── GET /users ────────────────────────────────────────────────────────────
  static Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((j) => Usuario.fromJson(j)).toList();
    }

    throw Exception('Falha ao carregar usuários (${response.statusCode})');
  }

  // ── POST /users ───────────────────────────────────────────────────────────
  static Future<Usuario> criarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: _jsonHeader,
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    }

    throw Exception('Falha ao criar usuário (${response.statusCode})');
  }

  // ── PUT /users/{id} ───────────────────────────────────────────────────────
  static Future<Usuario> atualizarUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/${usuario.id}'),
      headers: _jsonHeader,
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    }

    throw Exception('Falha ao atualizar usuário (${response.statusCode})');
  }

  // ── DELETE /users/{id} ────────────────────────────────────────────────────
  static Future<void> deletarUsuario(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/users/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar usuário (${response.statusCode})');
    }
  }
}
