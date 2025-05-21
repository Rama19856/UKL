import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav(this.currentIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Mata Kuliah',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home'); // Definisikan rute '/home'
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/mata_kuliah'); // Definisikan rute '/transaksi'
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/profile'); // Definisikan rute '/pengaturan'
            break;
        }
      },
    );
  }
}