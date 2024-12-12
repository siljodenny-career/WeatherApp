import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/services/location_services.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final LocationServices _locationServices = LocationServices();

  Placemark? _currentLocationName;
  Placemark? get currentLocatonName => _currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();

    _currentLocationName =
        await _locationServices.getLocationName(_currentPosition);

    notifyListeners();
  }
}
