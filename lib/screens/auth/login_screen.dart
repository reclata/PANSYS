import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // TODO: Implementar Firebase Auth Sign-In aqui
    // Simulando tempo de rede por enquanto
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Beautiful dynamic background
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Animation
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          // Decorational overlay blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: const SizedBox.shrink(),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bakery_dining_rounded,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "PanSys",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Gestão Inteligente para Padarias",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withOpacity(0.6),
                                ),
                          ),
                          const SizedBox(height: 48),

                          // Campos de texto
                          _buildTextField(
                            controller: _emailController,
                            label: "Email ou CPF",
                            icon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _passwordController,
                            label: "Senha",
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                          ),

                          // Esqueceu senha
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              child: const Text("Esqueceu a senha?"),
                            ),
                          ),

                          const SizedBox(height: 32),
                          // Botão Entrar
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "ENTRAR",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            "v1.0.0",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
