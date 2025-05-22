import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../model/anzirat_model.dart';

class AnziratViewModel extends ChangeNotifier {
  AppModel? appModel;
  bool isOnline = false;
  final Set<Marker> merkers ={};
  StreamSubscription<DocumentSnapshot>? _subscription;

  Future<void> getMarkers() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc("sotti")
          .collection("markers")
          .get();
      merkers.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final double lat = data['lat'] ?? 0.0;
        final double long = data['long'] ?? 0.0;

        final m = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, long),
        );
        print(data);
        merkers.add(m);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Get Marker failed: $e');
      rethrow;
    }
  }


  Future<void> init() async {
    if (appModel == null) {
      await _loadInitialData();
    }
    startListening();
  }

  void startListening() {
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc('sotti')
        .snapshots()
        .listen(
          _onDataChanged,
          onError: (error) {
            print("Stream xatosi: $error");
          },
        );
  }

  Future<void> _onDataChanged(DocumentSnapshot doc) async {
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;

    final locationMap = data['location'] as Map<String, dynamic>?;
    final bool online = data['isOnline'] ?? false;
    if (locationMap != null) {
      final model = AppModel.fromJson(locationMap);
      final locationName = await fetchDetailedLocationName(
        model.latitude,
        model.longitude,
      );

      appModel = model.copyWith(
        locationName: locationName ?? "Joylashuv nomi aniqlanmadi",
        isOnline: online,
      );
    }

    isOnline = online;
    notifyListeners();
  }

  Future<void> _loadInitialData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc('sotti')
              .get();

      if (!doc.exists) {
        print("Hujjat topilmadi.");
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final locationMap = data['location'] as Map<String, dynamic>?;
      final bool online = data['isOnline'] ?? false;

      if (locationMap != null) {
        final model = AppModel.fromJson(locationMap);
        final locationName = await fetchDetailedLocationName(
          model.latitude,
          model.longitude,
        );

        appModel = model.copyWith(
          locationName: locationName ?? "Joylashuv nomi aniqlanmadi",
          isOnline: online,
        );
      }

      isOnline = online;
      notifyListeners();
    } catch (e) {
      print("Xatolik: $e");
    }
  }

  Future<String?> fetchDetailedLocationName(double lat, double long) async {
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$lat+$long&key=9416bf2c8b1d4751be6a9a9e94ea85ca&language=en&no_annotations=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];
        if (results != null && results.isNotEmpty) {
          final components = results[0]['components'] as Map<String, dynamic>;

          final district = components['county'] ?? '';
          final neighbourhood = components['neighbourhood'] ?? '';
          final locality = components['locality'] ?? '';
          final houseNumber = components['house_number'] ?? '';
          final city = components['city'] ?? '';
          final suburb = components['suburb'] ?? '';
          final postcode = components['postcode'] ?? '';
          final country = components['country'] ?? '';

          String address = '';

          if (district.isNotEmpty) address += '$district, ';
          if (neighbourhood.isNotEmpty) address += '$neighbourhood, ';
          if (locality.isNotEmpty) address += '$locality, ';
          if (houseNumber.isNotEmpty) address += 'uy $houseNumber, ';
          if (suburb.isNotEmpty) address += '$suburb, ';
          if (city.isNotEmpty) address += '$city, ';
          if (postcode.isNotEmpty) address += '$postcode, ';
          if (country.isNotEmpty) address += '$country';

          address = address.trim();
          if (address.endsWith(',')) {
            address = address.substring(0, address.length - 1);
          }

          return address.isNotEmpty ? address : null;
        } else {
          print("Hech qanday natija topilmadi.");
        }
      } else {
        print('API xatosi: ${response.statusCode}');
      }
    } catch (e) {
      print('API chaqiruvda xatolik: $e');
    }

    return null;
  }

  void stopListening() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
