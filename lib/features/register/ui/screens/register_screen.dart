import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:laboratorio5_apps/components/error_message.dart';
import 'package:laboratorio5_apps/components/primary_button.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_bloc.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_event.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_state.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';

/// Formulario de registro: usuario, nombre completo, correo y contraseña.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Error de las validaciones que se resuelven en la pantalla.
  String? _validationError;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _validationError = null);

    if (username.isEmpty ||
        fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() => _validationError = 'Completa todos los campos');
      return;
    }
    if (password != _confirmPasswordController.text) {
      setState(() => _validationError = 'Las contraseñas no coinciden');
      return;
    }

    // El formulario solo lanza el evento: el Bloc decide qué pasa después.
    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: state.profile,
                );
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                // El formulario toma del estado el isLoading y el mensaje.
                final errorMessage = state.status == RegisterStatus.failure
                    ? state.errorMessage
                    : _validationError;

                return _buildForm(
                  isLoading: state.status == RegisterStatus.loading,
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
          'Crea tu cuenta',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Completa tus datos para registrarte',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _usernameController,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Nombre de usuario',
            prefixIcon: Icon(Icons.alternate_email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _fullNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nombre completo',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirmar contraseña',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 24),
        if (errorMessage != null) ...[
          ErrorMessage(message: errorMessage),
          const SizedBox(height: 16),
        ],
        PrimaryButton(
          label: 'Registrarme',
          isLoading: isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('¿Ya tienes cuenta? Inicia sesión'),
          ),
        ),
      ],
    );
  }
}
