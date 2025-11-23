import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/sizes.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark =  THelperFunctions.isDarkMode(context);
    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///Title
              Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: TSizes.spaceBtwSections),
              ///Signup Form
              Form(child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                      child:TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.firstName,prefixIcon: Icon(Iconsax.user)),
                      ),
                      ),
                      SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                      child:TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.lastName,prefixIcon: Icon(Iconsax.user)),
                      ),
                      ),
                     
                    ],
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  //username
                  TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.username ,prefixIcon: Icon(Iconsax.user_edit)),
                      ),
                  SizedBox(height: TSizes.spaceBtwInputFields),

                  // Email
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: TTexts.email,
                      prefixIcon: Icon(Iconsax.direct),
                    ),
                  ), // TextFormField

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Phone Number
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: TTexts.phoneNo,
                      prefixIcon: Icon(Iconsax.call),
                    ),
                  ), // TextFormField

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Password
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ), // InputDecoration
                  ), // TextFormField

                  const SizedBox(height: TSizes.spaceBtwSections),
                  // Terms&Conditions Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 24,
                      child: Checkbox(value: true, onChanged: (value) {}),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${TTexts.iAgreeTo} ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: TTexts.privacyPolicy,
                            style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  color: dark ? TColors.white : TColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: dark ? TColors.white : TColors.primary,
                                ),
                          ), // TextSpan
                          TextSpan(
                            text: ' ${TTexts.and} ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: TTexts.termsOfUse,
                            style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  color: dark ? TColors.white : TColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: dark ? TColors.white : TColors.primary,
                                ),
                          ), // TextSpan
                        ],
                      ),
                    ), // Text.rich
                  ],
                ), // Row


                ],
              ),),
            ],
          ),
        ),
      ),
    );
  }
}