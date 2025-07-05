import 'package:flutter/material.dart';
import 'package:mobile_iot/iam/application/sign_in_use_case.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/iam/infrastructure/service/auth_api_service.dart';
import 'package:mobile_iot/iam/infrastructure/repositories/auth_repository_impl.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';
import 'package:mobile_iot/shared/widgets/app_text_field.dart';
import 'package:mobile_iot/shared/widgets/app_button.dart';
import 'package:mobile_iot/iam/presentation/widgets/app_welcome_section.dart';

import '../../shared/widgets/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final credentials = Credentials(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      final repository = AuthRepositoryImpl(AuthApiService());
      final signInUseCase = SignInUseCase(repository);
      final token = await signInUseCase.execute(credentials);

      if (token != null) {
        final secureStorage = SecureStorageService();
        await secureStorage.saveToken(token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    const Spacer(flex: 2),
                    const AppLogo(fontSize: 36),

                    const SizedBox(height: 60),

                    // Welcome section
                    const AppWelcomeSection(
                      title: 'Welcome back!',
                      subtitle: 'Login to your account',
                    ),

                    const SizedBox(height: 40),

                    // Form
                    _buildLoginForm(),

                    const SizedBox(height: 24),

                    const SizedBox(height: 32),

                    // Login button
                    AppButton(
                      text: 'Sign in',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username field
          AppTextField(
            controller: _usernameController,
            hintText: 'Username',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password field
          AppTextField(
            controller: _passwordController,
            hintText: 'Password',
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.mediumGray,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
