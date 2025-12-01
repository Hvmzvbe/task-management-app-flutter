
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/constants/text_strings.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TformDevider extends StatelessWidget {
  const TformDevider({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final  dark =THelperFunctions.isDarkMode(Get.context!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey , thickness: 0.5,indent: 60,endIndent: 5)),
      Text(TTexts.orSignInWith.capitalize!, style: Theme.of(context).textTheme.bodyMedium),
      Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey , thickness: 0.5,indent: 5,endIndent: 60)),
    
      ],
    );
  }
}