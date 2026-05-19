// lib/screens/formulario_screen.dart
//
// Tela única para POST (criar) e PUT (editar).
// Quando usuario != null → modo edição.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tema.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/widgets.dart';

class FormularioScreen extends StatefulWidget {
  final Usuario? usuario;

  const FormularioScreen({super.key, this.usuario});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nomeCtrl   = TextEditingController();
  final _emailCtrl  = TextEditingController();
  final _telCtrl    = TextEditingController();
  final _siteCtrl   = TextEditingController();
  bool _salvando    = false;

  bool get _editando => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      _nomeCtrl.text  = widget.usuario!.nome;
      _emailCtrl.text = widget.usuario!.email;
      _telCtrl.text   = widget.usuario!.telefone;
      _siteCtrl.text  = widget.usuario!.site;
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _siteCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final usuario = Usuario(
      id: _editando ? widget.usuario!.id : 0,
      nome: _nomeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telefone: _telCtrl.text.trim(),
      site: _siteCtrl.text.trim(),
    );

    try {
      if (_editando) {
        await ApiService.atualizarUsuario(usuario);
      } else {
        await ApiService.criarUsuario(usuario);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Tema.sucesso, size: 18),
              const SizedBox(width: 10),
              Text(_editando ? 'Contato atualizado!' : 'Contato criado!'),
            ],
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Tema.erro, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text('Erro: $e')),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar contato' : 'Novo contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar de preview
              if (_editando) ...[
                Center(child: AvatarUsuario(usuario: widget.usuario!, tamanho: 72)),
                const SizedBox(height: 28),
              ] else
                const SizedBox(height: 8),

              // ── Campos ────────────────────────────────────────
              CampoTexto(
                controller: _nomeCtrl,
                label: 'Nome completo',
                icone: Icons.person_outline_rounded,
                validador: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 14),

              CampoTexto(
                controller: _emailCtrl,
                label: 'E-mail',
                icone: Icons.mail_outline_rounded,
                teclado: TextInputType.emailAddress,
                validador: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                  if (!v.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              CampoTexto(
                controller: _telCtrl,
                label: 'Telefone (opcional)',
                icone: Icons.phone_outlined,
                teclado: TextInputType.phone,
              ),
              const SizedBox(height: 14),

              CampoTexto(
                controller: _siteCtrl,
                label: 'Site (opcional)',
                icone: Icons.language_outlined,
                teclado: TextInputType.url,
              ),
              const SizedBox(height: 32),

              // ── Botão salvar ──────────────────────────────────
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_editando ? 'Salvar alterações' : 'Criar contato'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
