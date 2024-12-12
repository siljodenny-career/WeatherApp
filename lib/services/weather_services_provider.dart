import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather_response_model.dart';
import 'package:weatherapp/secrets/weather_api.dart';
import 'package:http/http.dart' as http;

class WeatherServicesProvider extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  String? _error = "";
  String? get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isLoading = true;
    _error = "";

    try {
      final String apiUrl =
          "${APIEndpoints().cityUrl}$city${APIEndpoints().apiKey}${APIEndpoints().unit}";
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _weather = WeatherModel.fromJson(data);
        notifyListeners();
      } else {
        _error = "Faled to load data";
      }
    } catch (e) {
      _error = "Failed $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
