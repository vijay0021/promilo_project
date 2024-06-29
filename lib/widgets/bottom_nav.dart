import 'package:flutter/material.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider, int>(
        selector: (c, p) => p.currentIndex,
        builder: (context, currentIndex, child) {
          return BottomNavigationBar(
              onTap: (index) => context.read<HomeProvider>().setCurrentIndex(index),
              currentIndex: currentIndex,
              elevation: 5,
              selectedItemColor: kPrimaryColor,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.black,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Prolet'),
                BottomNavigationBarItem(icon: Icon(Icons.handshake), label: 'Meetup'),
                BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Explore'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
              ]);
        });
  }
}