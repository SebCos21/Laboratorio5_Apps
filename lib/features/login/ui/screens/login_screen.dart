import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:laboratorio5_apps/components/error_message.dart';
import 'package:laboratorio5_apps/components/primary_button.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_bloc.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_event.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_state.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';

/// Formulario de inicio de sesión: correo y contraseña.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Error de las validaciones que se resuelven en la pantalla.
  String? _validationError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _validationError = null);

    if (email.isEmpty || password.isEmpty) {
      setState(() => _validationError = 'Escribe tu correo y tu contraseña');
      return;
    }

    // El formulario solo lanza el evento: el Bloc decide qué pasa después.
    context.read<LoginBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: state.profile,
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                // El formulario toma del estado el isLoading y el mensaje.
                final errorMessage = state.status == LoginStatus.failure
                    ? state.errorMessage
                    : _validationError;

                return _buildForm(
                  isLoading: state.status == LoginStatus.loading,
                  errorMessage: errorMessage,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm({required bool isLoading, String? errorMessage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bienvenido de nuevo',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa con tu correo y tu contraseña',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Correo',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 24),
        if (errorMessage != null) ...[
          ErrorMessage(message: errorMessage),
          const SizedBox(height: 16),
        ],
        PrimaryButton(
          label: 'Iniciar sesión',
          isLoading: isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
            child: const Text('¿No tienes cuenta? Regístrate'),
          ),
        ),
      ],
    );
  }
}
