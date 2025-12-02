import 'package:first_app/common/widgets/login_signup/form_devider.dart';
import 'package:first_app/common/widgets/login_signup/social_button.dart';
import 'package:first_app/screen/Auth/signup_page.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/utils/constants/image_strings.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:first_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,        
            left: 10,
            right: 24,
            bottom: 24
          ),
          child: Column(
            children: [
              TloginHeader(dark: dark),
              TloginForm(),
              TformDevider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),
              TSocialButton()
            ],
          )  
        ),
      ),
    );
  }
}

class TloginForm extends StatefulWidget {
  const TloginForm({super.key});

  @override
  State<TloginForm> createState() => _TloginFormState();
}

class _TloginFormState extends State<TloginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        THelperFunctions.showSnackBar('Connexion réussie! Bienvenue ${result['user'].firstName}');
        // TODO: Naviguer vers la page d'accueil
        // Get.offAll(() => HomePage());
      } else {
        THelperFunctions.showSnackBar(result['message']);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      THelperFunctions.showSnackBar('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: _emailController,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            
            // Password
            TextFormField(
              controller: _passwordController,
              validator: (value) => TValidator.validateEmptyText('Mot de passe', value),
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Remember Me",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                // Forgot password
                TextButton(
                  onPressed: () {
                    // TODO: Implémenter la récupération de mot de passe
                    THelperFunctions.showSnackBar('Fonctionnalité à venir');
                  },
                  child: const Text("Forgot Password?"),
                )
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
        
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            
            // Create account
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupPage()),
                child: Text(TTexts.createAccount),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections / 2),
          ],
        ),
      ),
    );
  }
}

class TloginHeader extends StatelessWidget {
  const TloginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
        ),
        Text(TTexts.logintitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.sm),
        Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}