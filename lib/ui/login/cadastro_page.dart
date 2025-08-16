import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'widgets/cover_carousel.dart';

class CadastroPage extends StatefulWidget {
  final Directory docsDir;
  const CadastroPage({super.key, required this.docsDir});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  bool obscure = true;
  bool aceitouTermos = false;

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final maxW = c.maxWidth > 520 ? 420.0 : c.maxWidth;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CoverCarousel(covers: _covers),
                    const SizedBox(height: 24),

                    const Text('Bem-vindo ao Harmony!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Milhões de músicas para ouvir agora.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 18),
                    Text('Cadastre-se para entrar no sistema',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 14),

                    _input(controller: nomeCtrl, hint: 'Nome Completo', icon: Icons.person_outline),
                    const SizedBox(height: 10),
                    _input(controller: emailCtrl, hint: 'Email', icon: Icons.alternate_email),
                    const SizedBox(height: 10),
                    _input(
                      controller: passCtrl,
                      hint: 'Senha',
                      icon: Icons.lock_outline,
                      obscure: obscure,
                      onToggleObscure: () => setState(() => obscure = !obscure),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: aceitouTermos,
                          onChanged: (v) => setState(() => aceitouTermos = v ?? false),
                          visualDensity: VisualDensity.compact,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                              children: [
                                const TextSpan(text: 'Ao marcar, você concorda com os '),
                                TextSpan(
                                  text: 'Termos',
                                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () {/* abrir termos */},
                                ),
                                const TextSpan(text: ' e '),
                                TextSpan(
                                  text: 'Condições',
                                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () {/* abrir condições */},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: scheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: aceitouTermos ? _cadastrar : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_right_alt_rounded, size: 22),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _cadastrarComGoogle,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Continue with Google'),
                    ),

                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Já possui conta?', style: TextStyle(color: Colors.grey[700])),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.pop(context), // volta pro login
                          child: Text('Faça Login',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // MOCK: quando integrar com Firebase, crie o usuário e então navegue.
  void _cadastrar() {
    if (nomeCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _cadastrarComGoogle() {
    // TODO: google_sign_in; depois redirecionar
    _cadastrar();
  }
}

Widget _input({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  VoidCallback? onToggleObscure,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: onToggleObscure != null
          ? IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 18),
        onPressed: onToggleObscure,
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
  );
}

const _covers = <String>[
  'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
  'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400',
  'https://images.unsplash.com/photo-1518972559570-7cc1309f3229?w=400',
  'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400',
  'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
  'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
];
