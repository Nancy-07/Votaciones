import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:votaciones/sreen/home_screen.dart';
import 'package:votaciones/sreen/resultados.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context){
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const[
            NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.add_chart_outlined), label: 'Resultados'),
          ],
        )
      ),
      body: Obx ( ()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [ HomeScreen(), ResultPage()];
}