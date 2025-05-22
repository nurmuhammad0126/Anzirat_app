import 'dart:async';

import 'package:anzirat_app/view_model/anzirat_view_model.dart';
import 'package:anzirat_app/views/home_screen.dart';
import 'package:anzirat_app/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late Future<void> _initFuture;
  Timer? _timer;
  int _currentIndex = 0;
  final List<Widget> _screens = [HomeScreen(), MapScreen()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initFuture = context.read<AnziratViewModel>().init();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Xatolik: ${snapshot.error}')),
          );
        }

        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: "MAP",
              ),
            ],
          ),
        );
      },
    );
  }
}
