import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/beranda_screen.dart';
import 'screens/tambah_tugas_penting_screen.dart';
import 'screens/tambah_tugas_biasa_screen.dart';
import 'screens/daftar_tugas_screen.dart';
import 'screens/pengaturan_screen.dart';
import 'utils/constants.dart';

class AgendaNusantaraApp extends StatelessWidget {
  const AgendaNusantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Segoe UI',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(AppConstants.COLOR_PRIMARY),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(AppConstants.COLOR_PRIMARY),
              width: 2,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        AppConstants.ROUTE_LOGIN: (context) => const LoginScreen(),
        AppConstants.ROUTE_HOME: (context) => const BerandaScreen(),
        AppConstants.ROUTE_TAMBAH_PENTING: (context) =>
            const TambahTugasPentingScreen(),
        AppConstants.ROUTE_TAMBAH_BIASA: (context) =>
            const TambahTugasBiasaScreen(),
        AppConstants.ROUTE_DAFTAR: (context) => const DaftarTugasScreen(),
        AppConstants.ROUTE_SETTINGS: (context) => const PengaturanScreen(),
      },
    );
  }
}
