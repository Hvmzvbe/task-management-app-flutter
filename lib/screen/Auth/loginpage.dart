import 'package:first_app/common/style/spacing_styles.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/constants/image_strings.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return  Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: TSizingStyle.paddingWithAppBarHeight,
        child : Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  height: 150,
                  image: AssetImage(TImages.lightAppLogo)//(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                  ),
                  Text(TTexts.logintitle, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: TSizes.sm),
                  Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            //form
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                child: Column(
                children: [
                  //mail
                  TextFormField(
                    decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right) , labelText: TTexts.email),
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
                  SizedBox(width : double.infinity , child : OutlinedButton(onPressed: (){}, child:Text(TTexts.createAccount) )),
                  const SizedBox(height: TSizes.spaceBtwSections),
                
                ],
                            ),
              ),
              ),

              //devider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey , thickness: 0.5,indent: 60,endIndent: 5)),
                Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey , thickness: 0.5,indent: 5,endIndent: 60)),

                ],
              )
          ],
        )  
        ),
      ),
    );
  }
}