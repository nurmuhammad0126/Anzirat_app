import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../view_model/anzirat_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final viwModel = context.read<AnziratViewModel>();
    
    final appModel = viwModel.appModel;
    LatLng initialLocation = LatLng(appModel!.latitude, appModel.longitude);
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
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Consumer<AnziratViewModel>(
        builder: (_, valu, __) {
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (lanlong) async {
            },
            markers: viwModel.merkers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              zoom: 14,
              target: initialLocation,
            ),
          );
        },
      ),
    );
  }
}
