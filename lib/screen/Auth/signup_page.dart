import 'package:first_app/common/widgets/login_signup/form_devider.dart';
import 'package:first_app/common/widgets/login_signup/social_button.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:first_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/sizes.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: TSizes.spaceBtwSections),
              TSignUpform(dark: dark),
              SizedBox(height: TSizes.spaceBtwSections),
              TformDevider(dividerText: TTexts.orSignUpWith.capitalize!),
              SizedBox(height: TSizes.spaceBtwSections),
              TSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TSignUpform extends StatefulWidget {
  const TSignUpform({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  State<TSignUpform> createState() => _TSignUpformState();
}

class _TSignUpformState extends State<TSignUpform> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      THelperFunctions.showSnackBar('Veuillez accepter les conditions d\'utilisation');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signUp(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        THelperFunctions.showAlert(
          'Succès',
          'Votre compte a été créé avec succès! Bienvenue ${result['user'].firstName}',
        );
        // Retourner à la page de connexion après 2 secondes
        await Future.delayed(Duration(seconds: 2));
        Get.back();
        // Ou naviguer vers la page d'accueil
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  validator: (value) => TValidator.validateEmptyText('Prénom', value),
                  decoration: InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  validator: (value) => TValidator.validateEmptyText('Nom', value),
                  decoration: InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          
          // Username
          TextFormField(
            controller: _usernameController,
            validator: TValidator.validateUsername,
            decoration: InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
      
          // Email
          TextFormField(
            controller: _emailController,
            validator: TValidator.validateEmail,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
      
          const SizedBox(height: TSizes.spaceBtwInputFields),
      
          // Phone Number
          TextFormField(
            controller: _phoneController,
            validator: TValidator.validatePhoneNumber,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
      
          const SizedBox(height: TSizes.spaceBtwInputFields),
      
          // Password
          TextFormField(
            controller: _passwordController,
            validator: TValidator.validatePassword,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
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
            onFieldSubmitted: (_) => _handleSignup(),
          ),
      
          const SizedBox(height: TSizes.spaceBtwSections),
          
          // Terms & Conditions Checkbox
          Row(
            children: [
              SizedBox(
                width: 16,
                height: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${TTexts.iAgreeTo} ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: TTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark ? TColors.white : TColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark ? TColors.white : TColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' ${TTexts.and} ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: TTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark ? TColors.white : TColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark ? TColors.white : TColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Signup Button
          SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignup,
              child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}