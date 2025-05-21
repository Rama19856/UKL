import 'package:flutter/material.dart';
import 'package:ukl1/views/login_view.dart';
import 'package:ukl1/views/matakuliah.dart';
import 'package:ukl1/views/profile.dart';
import 'package:ukl1/views/register_user_view.dart';
import 'package:ukl1/views/view_dashboard.dart';
import 'package:ukl1/views/profile.dart';


void main() {
  runApp(MaterialApp(
    title: 'UKL 1',
    initialRoute: '/register',
    routes: {
  '/login': (context) => const LoginView(),
  '/register': (context) => const RegisterUserView(),
  '/dashboard': (context) => const DashboardView(),
  '/mata_kuliah': (context) => const MataKuliahPage(),
  '/profile': (context) => const Profile(),// HAPUS const di sini
    },
  ));
}
