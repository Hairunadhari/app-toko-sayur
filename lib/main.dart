// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/pages/intro_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://luzzeizpeannziurkzmk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1enplaXpwZWFubnppdXJrem1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzOTM2MTMsImV4cCI6MjA3OTk2OTYxM30.Wy0SO7kZdk_8yMsiUxDO6KD72Y7tz1wevorGr7ELXE4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(), 
      ),
    );
  }
}