import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:noviindus_patients/domain/repositories/treatment_repository.dart';
import 'package:noviindus_patients/presentation/providers/branch_provider.dart';
import 'package:noviindus_patients/presentation/providers/patient_provider.dart';
import 'package:noviindus_patients/presentation/providers/treatment_provider.dart';
import 'package:provider/provider.dart';
import 'package:noviindus_patients/core/theme/app_theme.dart';
import 'package:noviindus_patients/presentation/providers/auth_provider.dart';
import 'package:noviindus_patients/screend/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
         ChangeNotifierProvider<PatientProvider>(create: (_) => PatientProvider()),
           ChangeNotifierProvider<BranchProvider>(create: (_) => BranchProvider()), // 
           ChangeNotifierProvider(create: (_) => TreatmentProvider(TreatmentRepository())),
        // ChangeNotifierProvider(create: (_) => SomeOtherProvider()),
      ],
      child: MaterialApp(
        title: 'Hospital App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
