// ignore_for_file: deprecated_member_use

import 'package:first_app/screen/Home/HomeScreen.dart';
import 'package:first_app/screen/NotificationsScreen.dart';
import 'package:first_app/screen/ProfileScreen.dart';
import 'package:first_app/screen/TasksScreen.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode 
            ? TColors.white.withOpacity(0.1) 
            : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.task_square),
              label: 'Tâches',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.notification),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'Profil',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const TasksScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];
}















