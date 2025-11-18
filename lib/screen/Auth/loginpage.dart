import 'package:first_app/common/style/spacing_styles.dart';
import 'package:first_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSizingStyle.paddingWithAppBarHeight,
        child : Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            )
          ],
        )  
        ),
      ),
    );
  }
}