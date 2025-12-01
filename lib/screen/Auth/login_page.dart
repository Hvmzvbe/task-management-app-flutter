
import 'package:first_app/common/widgets/login_signup/form_devider.dart';
import 'package:first_app/common/widgets/login_signup/social_button.dart';
import 'package:first_app/screen/Auth/signup_page.dart';
import 'package:first_app/utils/constants/image_strings.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark =  THelperFunctions.isDarkMode(context);
    return  Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          //padding: TSizingStyle.paddingWithAppBarHeight,
          padding: const EdgeInsets.only(
          top: 20,        
          left: 10,
          right: 24,
          bottom: 24
          ),


        child : Column(
          children: [
            TloginHeader(dark: dark),
            //form
            TloginForm(),
              //devider
            TformDevider(dividerText: TTexts.orSignInWith.capitalize!,),
            const SizedBox(height: TSizes.spaceBtwSections),
              //footer
            TSocialButton()

          ],
        )  
        ),
      ),
    );
  }
}



























class TloginForm extends StatelessWidget {
  const TloginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
        children: [
          //mail
          TextFormField(
            decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right) , labelText: TTexts.email ),
            
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //password
          TextFormField(
            decoration: InputDecoration(prefixIcon: Icon(Iconsax.password_check) , labelText: TTexts.password , suffixIcon: Icon(Iconsax.eye_slash)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields /2),
          Row(
            children: [
              //remember me
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Text("Remember Me", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              // forgot password
              TextButton(onPressed: (){}, child: const Text("Forgot Password?"))
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        
          SizedBox(width : double.infinity , child : ElevatedButton(onPressed: (){}, child:Text(TTexts.signIn)) ),
          const SizedBox(height: TSizes.spaceBtwSections),
          //create account
          SizedBox(width : double.infinity , child : OutlinedButton(onPressed: ()=>Get.to(()=>const SignupPage()), child:Text(TTexts.createAccount) )),
          const SizedBox(height: TSizes.spaceBtwSections/2),
        
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