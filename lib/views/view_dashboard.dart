import 'package:flutter/material.dart';
import 'package:ukl1/models/user_login.dart';
import 'package:ukl1/widgets/bottom_nav.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? username;

  getUserLogin() async {
    var user = await UserLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama;
        username = user.username;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(child: Text("Selamat Datang $nama (Username: $username)")),
      bottomNavigationBar: const BottomNav(0), // Gunakan BottomNav widget
    );
  }
}