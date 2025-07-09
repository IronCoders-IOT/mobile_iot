import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';
import 'package:mobile_iot/iam/domain/logic/auth_validators.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';
import 'package:mobile_iot/shared/widgets/app_text_field.dart';
import 'package:mobile_iot/shared/widgets/app_button.dart';
import 'package:mobile_iot/iam/presentation/widgets/app_welcome_section.dart';
import 'package:mobile_iot/iam/presentation/bloc/bloc.dart';
import '../../shared/widgets/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../../main.dart';

/// A screen that handles user authentication and login.
/// 
/// This screen provides a form interface for users to authenticate
/// with their username and password. It handles form validation,
/// authentication requests, and navigation to the main app after
/// successful login.
/// 
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The state class for the LoginScreen widget.
/// 
/// This class manages the form state, text controllers, and password visibility
/// for the login screen. The authentication logic is handled by the AuthBloc
/// following the BLoC pattern for clean separation of concerns.
/// 
class _LoginScreenState extends State<LoginScreen> {
  /// Global key for form validation.
  /// 
  /// This key is used to access the form's validation state and trigger
  /// validation when the user attempts to sign in.
  final _formKey = GlobalKey<FormState>();
  
  /// Text controller for username input field.
  /// 
  /// Manages the text input for the username field and provides access
  /// to the current value for form submission.
  final _usernameController = TextEditingController();
  
  /// Text controller for password input field.
  /// 
  /// Manages the text input for the password field and provides access
  /// to the current value for form submission.
  final _passwordController = TextEditingController();
  
  /// Flag to control password visibility in the password field.
  /// 
  /// When true, the password is visible as plain text.
  /// When false, the password is obscured with dots.
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the login authentication process.
  /// 
  /// This method validates the form and dispatches a login event
  /// to the AuthBloc for processing. It creates a Credentials object
  /// from the form inputs and triggers the authentication flow.
  /// 
  /// The method:
  /// - Validates the form using the form key
  /// - Creates a Credentials object from username and password
  /// - Dispatches a LoginEvent to the AuthBloc
  /// - Handles the authentication flow asynchronously
  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;
    
    final credentials = Credentials(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    context.read<LoginBloc>().add(SignInEvent(credentials: credentials));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      // Listen for state changes to handle side effects (like navigation)
      listener: (context, state) {
        if (state is AuthSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginSuccessful),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      // Build the UI based on the current state
      builder: (context, state) {
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
                        // Language switcher aligned to the right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildLanguageDropdown(context),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // App logo section
                        const AppLogo(fontSize: 36),
                        const SizedBox(height: 60),
                        // Welcome message section
                        AppWelcomeSection(
                          title: AppLocalizations.of(context)!.welcomeBack,
                          subtitle: AppLocalizations.of(context)!.loginToYourAccount,
                        ),
                        const SizedBox(height: 40),
                        // Login form with username and password fields
                        _buildLoginForm(),
                        const SizedBox(height: 24),
                        const SizedBox(height: 32),
                        // Sign in button
                        _buildSignInButton(state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the login form with username and password fields.
  /// 
  /// This method creates a form widget containing username and password
  /// input fields with appropriate validation using the auth validators
  /// from the domain logic layer. The form includes:
  /// - Username field with text input validation
  /// - Password field with visibility toggle and validation
  /// - Proper keyboard actions for form navigation
  /// - Form validation integration
  /// 
  /// Returns a Form widget with login input fields.
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username field
          AppTextField(
            controller: _usernameController,
            hintText: AppLocalizations.of(context)!.username,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: validateUsername,
          ),

          const SizedBox(height: 16),

          // Password field
          AppTextField(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.password,
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
            validator: validatePassword,
          ),
        ],
      ),
    );
  }

  /// Builds the sign in button based on the current authentication state.
  /// 
  /// This method creates an AppButton widget that handles the login
  /// operation. The button adapts its behavior based on the current
  /// authentication state:
  /// - Shows loading indicator during authentication
  /// - Disables button during loading to prevent multiple submissions
  /// - Handles the login action when pressed
  /// 
  /// Parameters:
  /// - [state]: The current authentication state from AuthBloc
  /// 
  /// Returns an AppButton widget for signing in with appropriate state handling.
  Widget _buildSignInButton(LoginState state) {
    final isLoading = state is AuthLoadingState;
    return AppButton(
      text: AppLocalizations.of(context)!.signIn,
      onPressed: isLoading ? null : _handleLogin,
      isLoading: isLoading,
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    return DropdownButton<Locale>(
      value: currentLocale.languageCode == 'es' ? const Locale('es') : const Locale('en'),
      icon: const Icon(Icons.language, color: Colors.blue),
      underline: Container(height: 0),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          AquaConectaAppState.changeLocale(newLocale);
        }
      },
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: const Locale('es'),
          child: Text('Español'),
        ),
      ],
    );
  }
}
