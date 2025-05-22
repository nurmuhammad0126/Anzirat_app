import 'package:anzirat_app/view_model/anzirat_view_model.dart';
import 'package:anzirat_app/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnziratViewModel(),
      child: const MaterialApp(
        home: MainScreen()
      ),
    );
  }
}
