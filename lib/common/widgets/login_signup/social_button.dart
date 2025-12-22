import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/screen/NavigationMenu.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/constants/image_strings.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TSocialButton extends StatelessWidget {
  const TSocialButton({
    super.key,
  });

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (success) {
      THelperFunctions.showSnackBar(
        'Bienvenue ${authProvider.currentUser?.firstName}!'
      );
      Get.offAll(() => const NavigationMenu());
    } else {
      // Si l'utilisateur annule, ne pas afficher d'erreur
      if (authProvider.errorMessage != null && 
          !authProvider.errorMessage!.contains('annulée')) {
        THelperFunctions.showSnackBar(
          authProvider.errorMessage ?? 'Erreur de connexion'
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton Google
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: TColors.grey),
                borderRadius: BorderRadius.circular(100)
              ),
              child: IconButton(
                onPressed: authProvider.isLoading 
                    ? null 
                    : () => _handleGoogleSignIn(context),
                icon: authProvider.isLoading
                    ? SizedBox(
                        height: TSizes.iconMd,
                        width: TSizes.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            TColors.primary
                          ),
                        ),
                      )
                    : Image(
                        height: TSizes.iconMd,
                        width: TSizes.iconMd,
                        image: AssetImage(TImages.google),
                      ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems * 3),
            
            // Bouton GitHub (désactivé pour l'instant)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: TColors.grey),
                borderRadius: BorderRadius.circular(100)
              ),
              child: IconButton(
                onPressed: () {
                  THelperFunctions.showSnackBar(
                    'GitHub Sign-In: Fonctionnalité à venir'
                  );
                },
                icon: Image(
                  height: TSizes.iconMd,
                  width: TSizes.iconMd,
                  image: AssetImage(TImages.github),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}