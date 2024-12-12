import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/screens/home_page.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/services/weather_services_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) => LocationProvider(),),
        ChangeNotifierProvider(create: (context) => WeatherServicesProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation:0,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

