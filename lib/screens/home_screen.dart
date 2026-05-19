// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tema.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/widgets.dart';
import 'formulario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Usuario> _todos = [];
  List<Usuario> _filtrados = [];
  bool _carregando = true;
  String? _erro;
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregar();
    _buscaController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // ── GET ──────────────────────────────────────────────────────────────────
  Future<void> _carregar() async {
    setState(() { _carregando = true; _erro = null; });
    try {
      final lista = await ApiService.listarUsuarios();
      setState(() { _todos = lista; _filtrados = lista; });
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _carregando = false);
    }
  }

  // ── Busca local ───────────────────────────────────────────────────────────
  void _filtrar() {
    final termo = _buscaController.text.toLowerCase();
    setState(() {
      _filtrados = _todos
          .where((u) =>
              u.nome.toLowerCase().contains(termo) ||
              u.email.toLowerCase().contains(termo))
          .toList();
    });
  }

  // ── Navegar para formulário de criação ────────────────────────────────────
  Future<void> _abrirCriacao() async {
    final criou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioScreen()),
    );
    if (criou == true) _carregar();
  }

  // ── Navegar para formulário de edição ─────────────────────────────────────
  Future<void> _abrirEdicao(Usuario usuario) async {
    final editou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormularioScreen(usuario: usuario)),
    );
    if (editou == true) _carregar();
  }

  // ── DELETE com confirmação ─────────────────────────────────────────────────
  Future<void> _confirmarDelete(Usuario usuario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Tema.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remover contato',
            style: GoogleFonts.playfairDisplay(
                color: Tema.textoForte, fontWeight: FontWeight.w700)),
        content: Text(
          'Deseja remover "${usuario.nome}" da sua lista?',
          style: GoogleFonts.dmSans(color: Tema.textoSuave),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Tema.erro),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await ApiService.deletarUsuario(usuario.id);
      setState(() {
        _todos.removeWhere((u) => u.id == usuario.id);
        _filtrar();
      });
      _snack('${usuario.nome} removido.', icone: Icons.check_circle_outline);
    } catch (e) {
      _snack('Erro ao remover: $e', erro: true);
    }
  }

  // ── SnackBar estilizado ───────────────────────────────────────────────────
  void _snack(String msg, {bool erro = false, IconData? icone}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icone ?? (erro ? Icons.error_outline : Icons.check_circle_outline),
              color: erro ? Tema.erro : Tema.sucesso,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildBusca(),
            _buildContador(),
            Expanded(child: _buildConteudo()),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'People OS',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Tema.textoForte,
                ),
              ),
              Text(
                'Gerenciador de contatos',
                style: GoogleFonts.dmSans(fontSize: 13, color: Tema.textoSuave),
              ),
            ],
          ),
          GestureDetector(
            onTap: _carregar,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Tema.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Tema.borda),
              ),
              child: const Icon(Icons.refresh_rounded, color: Tema.textoSuave, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Barra de busca ────────────────────────────────────────────────────────
  Widget _buildBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: TextField(
        controller: _buscaController,
        style: GoogleFonts.dmSans(color: Tema.textoForte, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou e-mail...',
          prefixIcon: const Icon(Icons.search_rounded, color: Tema.textoSuave, size: 20),
          suffixIcon: _buscaController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () { _buscaController.clear(); _filtrar(); },
                  child: const Icon(Icons.close_rounded, color: Tema.textoSuave, size: 18),
                )
              : null,
        ),
      ),
    );
  }

  // ── Contador ──────────────────────────────────────────────────────────────
  Widget _buildContador() {
    if (_carregando || _erro != null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Text(
        '${_filtrados.length} contato${_filtrados.length != 1 ? 's' : ''}',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: Tema.textoSuave,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Conteúdo principal ────────────────────────────────────────────────────
  Widget _buildConteudo() {
    if (_carregando) return const LoadingCenter();

    if (_erro != null) {
      return EstadoVazio(
        mensagem: 'Não foi possível carregar os contatos.\nVerifique sua conexão.',
        onAcao: _carregar,
        labelAcao: 'Tentar novamente',
      );
    }

    if (_filtrados.isEmpty) {
      return EstadoVazio(
        mensagem: _buscaController.text.isNotEmpty
            ? 'Nenhum resultado para "${_buscaController.text}"'
            : 'Nenhum contato encontrado.',
      );
    }

    return RefreshIndicator(
      color: Tema.acento,
      backgroundColor: Tema.card,
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        itemCount: _filtrados.length,
        itemBuilder: (_, i) => CardUsuario(
          usuario: _filtrados[i],
          onEditar: () => _abrirEdicao(_filtrados[i]),
          onDeletar: () => _confirmarDelete(_filtrados[i]),
        ),
      ),
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: _abrirCriacao,
      backgroundColor: Tema.acento,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.person_add_outlined, size: 20),
      label: Text('Novo contato', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
    );
  }
}
