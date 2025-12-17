import 'package:first_app/common/widgets/login_signup/form_devider.dart';
import 'package:first_app/common/widgets/login_signup/social_button.dart';
import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/screen/Auth/signup_page.dart';
import 'package:first_app/screen/NavigationMenu.dart';
import 'package:first_app/utils/constants/image_strings.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:first_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      THelperFunctions.showSnackBar(
        'Bienvenue ${authProvider.currentUser?.firstName}!'
      );
      Get.offAll(() => const NavigationMenu());
    } else {
      THelperFunctions.showSnackBar(
        authProvider.errorMessage ?? 'Erreur de connexion'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
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
                  enabled: !authProvider.isLoading,
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
                  enabled: !authProvider.isLoading,
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
                          onChanged: authProvider.isLoading ? null : (value) {
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
                      onPressed: authProvider.isLoading ? null : () {
                        THelperFunctions.showSnackBar('Fonctionnalité à venir');
                      },
                      child: const Text("Forgot Password?"),
                    )
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
            
                // Afficher l'erreur si elle existe
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: TSizes.spaceBtwInputFields),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleLogin,
                    child: authProvider.isLoading
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
                    onPressed: authProvider.isLoading ? null : () {
                      Get.to(() => const SignupPage());
                    },
                    child: Text(TTexts.createAccount),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections / 2),
              ],
            ),
          ),
        );
      },
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