import 'package:anzirat_app/view_model/anzirat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void dispose() {
    context.read<AnziratViewModel>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AnziratViewModel>().init();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Anzirat :)",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Consumer<AnziratViewModel>(
        builder: (_, viewModel, __) {
          final model = viewModel.appModel;

          if (model == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ma'lumotlar yuklanmoqda...",
                    style: TextStyle(fontSize: 18),
                  ),
                  CircularProgressIndicator(color: Colors.black),
                ],
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              SelectableText(
                "Latitude: ${model.latitude}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Longitude: ${model.longitude}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Accuracy: ${model.accuracy}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Altitude: ${model.altitude}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Speed: ${model.speed}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Heading: ${model.heading}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                "Location Name:",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              SelectableText(
                model.locationName ?? "",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                viewModel.isOnline ? "Status: Online ✅" : "Status: Offline ❌",
                style: TextStyle(
                  color: viewModel.isOnline ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
