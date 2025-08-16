import 'dart:io';
import 'package:flutter/material.dart';
import 'widgets/cover_carousel.dart';

class LoginInicio extends StatefulWidget {
  final Directory docsDir;
  const LoginInicio({super.key, required this.docsDir});

  @override
  State<LoginInicio> createState() => _LoginInicioState();
}

class _LoginInicioState extends State<LoginInicio> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool lembrar = false;
  bool obscure = true;

  @override
  void dispose() { emailCtrl.dispose(); passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // tela inteira branca (não é modal)
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // maxWidth pra web/desktop, mas fundo continua branco (tela cheia)
            final maxW = constraints.maxWidth > 520 ? 420.0 : constraints.maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // faixa de capas ocupando a largura da tela
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
                      Text('Faça login para entrar no sistema',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const SizedBox(height: 14),

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
                            value: lembrar,
                            onChanged: (v) => setState(() => lembrar = v ?? false),
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text('Lembrar de mim', style: TextStyle(fontSize: 12.5)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Esqueceu a senha?', style: TextStyle(fontSize: 12.5)),
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
                          onPressed: _entrar,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Entrar', style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_right_alt_rounded, size: 22),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _entrarComGoogle,
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
                          Text('Novo por aqui ?', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: Text('Cadastre-se',
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
          },
        ),
      ),
    );
  }

  void _entrar() {
    // TODO: autenticação real; se ok:
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _entrarComGoogle() {
    // TODO: google_sign_in / firebase_auth
    _entrar();
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
  'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400',
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
  'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400',
  'https://images.unsplash.com/photo-1518972559570-7cc1309f3229?w=400',
  'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400',
  'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
  'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
];
