// lib/widgets/widgets.dart
//
// Componentes visuais reutilizáveis.
// Cada widget tem uma única responsabilidade.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tema.dart';
import '../models/usuario.dart';

// ── Avatar circular colorido com iniciais ─────────────────────────────────

class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;
  final double tamanho;

  const AvatarUsuario({super.key, required this.usuario, this.tamanho = 44});

  @override
  Widget build(BuildContext context) {
    final cor = Tema.avatarCor(usuario.id);
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cor.withOpacity(0.15),
        border: Border.all(color: cor.withOpacity(0.4), width: 1.5),
      ),
      child: Center(
        child: Text(
          usuario.iniciais,
          style: GoogleFonts.dmSans(
            fontSize: tamanho * 0.35,
            fontWeight: FontWeight.w700,
            color: cor,
          ),
        ),
      ),
    );
  }
}

// ── Badge de informação (email, telefone, site) ───────────────────────────

class InfoBadge extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color? cor;

  const InfoBadge({
    super.key,
    required this.icone,
    required this.texto,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 13, color: cor ?? Tema.textoSuave),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: cor ?? Tema.textoSuave,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Card de usuário ───────────────────────────────────────────────────────

class CardUsuario extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Tema.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tema.borda),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AvatarUsuario(usuario: usuario),
            const SizedBox(width: 14),

            // Nome + infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usuario.nome,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  InfoBadge(icone: Icons.mail_outline_rounded, texto: usuario.email),
                  if (usuario.telefone.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    InfoBadge(icone: Icons.phone_outlined, texto: usuario.telefone),
                  ],
                ],
              ),
            ),

            // Ações
            Column(
              children: [
                _BotaoAcao(
                  icone: Icons.edit_outlined,
                  cor: Tema.acento,
                  onTap: onEditar,
                ),
                const SizedBox(height: 6),
                _BotaoAcao(
                  icone: Icons.delete_outline_rounded,
                  cor: Tema.erro,
                  onTap: onDeletar,
                ),
              ],
            ),
          ],
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
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icone, size: 17, color: cor),
      ),
    );
  }
}

// ── Estado vazio ──────────────────────────────────────────────────────────

class EstadoVazio extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onAcao;
  final String? labelAcao;

  const EstadoVazio({
    super.key,
    required this.mensagem,
    this.onAcao,
    this.labelAcao,
  });

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
          Text(
            mensagem,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
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
      child: CircularProgressIndicator(
        color: Tema.acento,
        strokeWidth: 2,
      ),
    );
  }
}

// ── Campo de formulário padronizado ──────────────────────────────────────

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
