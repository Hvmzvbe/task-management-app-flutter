import 'package:first_app/common/style/spacing_styles.dart';
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
                  image: AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                  ),
                  Text(TTexts.logintitle, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: TSizes.sm),
                  Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            //form
            Form(child: Column(
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
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text("Remember Me", style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    // forgot password
                    TextButton(onPressed: (){}, child: const Text("Forgot Password?"))
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                ElevatedButton(onPressed: (){}, child:Text(TTexts.signIn) )

              ],
            ))
          ],
        )  
        ),
      ),
    );
  }
}