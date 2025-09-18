import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/presentation/screens/home_screen.dart';

import 'capsules_screen.dart';
import 'launches_screen.dart';
import 'rockets_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
   late int tapCount = 0;
  late int currentIndex = 0;
  final screens = [const HomeScreen(), const CapsulesScreen(), const RocketsScreen(), const LaunchesScreen()];
  late Widget currentScreen;

  @override
  void initState() {
   // currentIndex = widget.screenIndex;
    currentScreen = screens[currentIndex];
    super.initState();
  }

  void changeScreen({required int selectedIndex}){
    setState(() {
      currentIndex = selectedIndex;
      currentScreen = screens[selectedIndex];
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          return;
        }
        tapCount++;

        if(tapCount == 1){
          // TODO: Add Toast
         // showToast(context: context);
        }
        else if(tapCount == 2){
          exit(0);
        }
        else{
          tapCount = 0;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: currentScreen,
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

   Widget buildBottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/home_icon.png',), size: 24,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/capsule_icon.png',), size: 24,),
          label: 'Capsules',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/rocket_icon.png',), size: 24,),
          label: 'Rockets',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/launch_icon.png',), size: 24,),
          label: 'Launches',
        ),
      ],
      elevation: 10,
      currentIndex: currentIndex,
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4),
      onTap: (selectedIndex) => changeScreen(selectedIndex: selectedIndex),
    );
  }

}
