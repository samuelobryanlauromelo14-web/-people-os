// lib/widgets/widgets.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tema.dart';
import '../models/usuario.dart';

// ── Avatar circular colorido com iniciais ─────────────────────────────────

class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;
  final double tamanho;

  const AvatarUsuario({super.key, required this.usuario, this.tamanho = 56});

  @override
  Widget build(BuildContext context) {
    final cor = Tema.avatarCor(usuario.id);
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [cor.withOpacity(0.35), cor.withOpacity(0.1)],
        ),
        border: Border.all(color: cor.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(color: cor.withOpacity(0.25), blurRadius: 12, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: Text(
          usuario.iniciais,
          style: GoogleFonts.dmSans(
            fontSize: tamanho * 0.33,
            fontWeight: FontWeight.w800,
            color: cor,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

// ── Badge de informação ───────────────────────────────────────────────────

class InfoBadge extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color? cor;

  const InfoBadge({super.key, required this.icone, required this.texto, this.cor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 13, color: cor ?? Tema.textoSuave),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: GoogleFonts.dmSans(fontSize: 12, color: cor ?? Tema.textoSuave),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Card de usuário com animação ──────────────────────────────────────────

class CardUsuario extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;

  const CardUsuario({
    super.key,
    required this.usuario,
    required this.onEditar,
    required this.onDeletar,
  });

  @override
  State<CardUsuario> createState() => _CardUsuarioState();
}

class _CardUsuarioState extends State<CardUsuario>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _escala;
  late Animation<double> _opacidade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _escala = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _opacidade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cor = Tema.avatarCor(widget.usuario.id);

    return FadeTransition(
      opacity: _opacidade,
      child: ScaleTransition(
        scale: _escala,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Tema.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cor.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                AvatarUsuario(usuario: widget.usuario, tamanho: 58),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.usuario.nome,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Tema.textoForte,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      InfoBadge(
                        icone: Icons.mail_outline_rounded,
                        texto: widget.usuario.email,
                      ),
                      if (widget.usuario.telefone.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        InfoBadge(
                          icone: Icons.phone_outlined,
                          texto: widget.usuario.telefone,
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    _BotaoAcao(
                      icone: Icons.edit_outlined,
                      cor: Tema.acento,
                      onTap: widget.onEditar,
                    ),
                    const SizedBox(height: 8),
                    _BotaoAcao(
                      icone: Icons.delete_outline_rounded,
                      cor: Tema.erro,
                      onTap: widget.onDeletar,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoAcao extends StatelessWidget {
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const _BotaoAcao({required this.icone, required this.cor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: cor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cor.withOpacity(0.25)),
        ),
        child: Icon(icone, size: 18, color: cor),
      ),
    );
  }
}

// ── Estado vazio ──────────────────────────────────────────────────────────

class EstadoVazio extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onAcao;
  final String? labelAcao;

  const EstadoVazio({super.key, required this.mensagem, this.onAcao, this.labelAcao});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Tema.card,
              shape: BoxShape.circle,
              border: Border.all(color: Tema.borda),
            ),
            child: const Icon(Icons.person_search_outlined, color: Tema.textoSuave, size: 32),
          ),
          const SizedBox(height: 16),
          Text(mensagem, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          if (onAcao != null) ...[
            const SizedBox(height: 20),
            TextButton(onPressed: onAcao, child: Text(labelAcao ?? 'Tentar novamente')),
          ],
        ],
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────

class LoadingCenter extends StatelessWidget {
  const LoadingCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Tema.acento, strokeWidth: 2),
    );
  }
}

// ── Campo de formulário ───────────────────────────────────────────────────

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icone;
  final TextInputType? teclado;
  final String? Function(String?)? validador;

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    required this.icone,
    this.hint,
    this.teclado,
    this.validador,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: teclado,
      style: GoogleFonts.dmSans(color: Tema.textoForte, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icone, size: 18, color: Tema.textoSuave),
      ),
      validator: validador,
    );
  }
}
