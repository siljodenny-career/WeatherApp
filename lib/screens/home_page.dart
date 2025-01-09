import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/data/image_path.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/services/weather_services_provider.dart';
import 'package:weatherapp/utils/apptext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final locationprovider =
        Provider.of<LocationProvider>(context, listen: false);
    locationprovider.determinePosition().then((_) {
      if (locationprovider.currentLocatonName != null) {
        var city = locationprovider.currentLocatonName?.locality;
        if (city != null) {
          // ignore: use_build_context_synchronously
          Provider.of<WeatherServicesProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
    super.initState();
  }

  bool _clicked = false;

  //Getting searched city from the textfield
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();

    //final locationProvider = Provider.of<LocationProvider>(context);

    final weatherProvider = Provider.of<WeatherServicesProvider>(context);

    //Get the sunrise/sunset from API response

    int sunriseTimeStamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimeStamp = weatherProvider.weather?.sys?.sunset ?? 0;

    //converting timestamp into Datetime
    DateTime sunriseDateTime =
        DateTime.fromMicrosecondsSinceEpoch(sunriseTimeStamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMicrosecondsSinceEpoch(sunsetTimeStamp * 1000);

    //formatting into String type
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding:size.width >=600 ? const EdgeInsets.symmetric(horizontal: 50, vertical: 50) :const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background[
                        weatherProvider.weather?.weather?[0].main ?? "N/A"] ??
                    background["Clear"]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                //header search section
                Align(
                  alignment: const Alignment(0, -1),
                  child: Container(
                    height: _clicked ? 110 : 70,
                    width: size.width>=600 ? 800 : 600,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        var locationCity =
                            locationProvider.currentLocatonName?.subLocality;
                        locationCity != null
                            ? locationCity = locationCity
                            : locationCity = "Unknown Location";
                        if (_cityController.text.isNotEmpty) {
                          locationCity = _cityController.text;
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 35,
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Apptext(
                                          data: locationCity,
                                          fw: FontWeight.w700,
                                          size: 22,
                                          color: const Color.fromARGB(
                                              255, 66, 64, 64),
                                        ),
                                        Apptext(
                                          data: DateFormat('a').format(now) ==
                                                  "AM"
                                              ? "Good Morning!"
                                              : "Good Evening",
                                          size: 15,
                                          fw: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 115, 113, 113),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                _clicked == false
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _clicked = !_clicked;
                                            
                                        
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.search,
                                          size: 28,
                                          color:
                                              Color.fromARGB(255, 66, 64, 64),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            _clicked
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _cityController,
                                          textCapitalization: TextCapitalization.words,
                                          enabled: true,
                                          showCursor: true,
                                          autocorrect: true,
                                          enableSuggestions: true,
                                          cursorColor: const Color.fromARGB(
                                              255, 66, 64, 64),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 66, 64, 64),
                                              fontSize: 18,
                                              decoration: TextDecoration.none),
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Search location by City",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15,
                                              ),
                                              prefix: SizedBox(
                                                width: 20,
                                              ),
                                              focusedBorder: InputBorder.none),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          weatherProvider
                                              .fetchWeatherDataByCity(
                                                  _cityController.text);
                                          locationCity = _cityController.text;
                                          setState(() {
                                            _clicked = !_clicked;
                                            
                                          });
                                          
                                        },
                                        icon: const Icon(Icons.search),
                                      )
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //body secton
                //-------------------

                Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0, -0.17),
                      child: Container(
                        height: size.height / 2.6,
                        width: size.width / 1.7,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 6, 6, 6)
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, -0.4),
                      child: Image.asset(
                        weatherimg[weatherProvider.weather?.weather?[0].main ??
                                "N/A"] ??
                            weatherimg["Default"],
                        width: 120,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.15),
                      child: SizedBox(
                        height: 150,
                        width: size.width,
                        //color: Colors.amber.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Apptext(
                              data:
                                  "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0) ?? "**"}\u00b0 C",
                              size: 50,
                              color: Colors.white,
                              ff: "Roboto",
                              fw: FontWeight.w900,
                            ),
                            Apptext(
                              data: weatherProvider.weather?.weather?[0].main
                                  .toString() ??"****",
                              size: 25,
                              color: Colors.white,
                              ff: "Roboto",
                              fw: FontWeight.w600,
                            ),
                            Apptext(
                              data:
                                  DateFormat('MMMM d, yyyy h:mm a').format(now),
                              size: 15,
                              color: Colors.white,
                              ff: "Roboto",
                              fw: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 1),
                      child: Container(
                        padding:size.height>=600 ? const EdgeInsets.all(20) :const EdgeInsets.all(10),
                        height:size.height>=600? size.height / 5 :size.height / 4,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      appicons["icon-temphigh"],
                                      width: 50,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Apptext(
                                          data: "Temp Max",
                                          color: Colors.white,
                                          fw: FontWeight.bold,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                        Apptext(
                                          data:
                                              "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(1)??"**"}\u00b0 C",
                                          color: Colors.white,
                                          fw: FontWeight.w400,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      appicons["icon-templow"],
                                      width: 50,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Apptext(
                                          data: "Temp Min",
                                          color: Colors.white,
                                          fw: FontWeight.bold,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                        Apptext(
                                          data:
                                              "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(1)??"**"}\u00b0 C",
                                          color: Colors.white,
                                          fw: FontWeight.w400,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Colors.white,
                              indent: 12,
                              endIndent: 12,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      appicons["icon-sun"],
                                      width: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      children: [
                                        Apptext(
                                          data: "Sunrise",
                                          color: Colors.white,
                                          fw: FontWeight.bold,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                        Apptext(
                                          data: "$formattedSunrise AM",
                                          color: Colors.white,
                                          fw: FontWeight.w300,
                                          size: 12,
                                          ff: "Roboto",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      appicons["icon-moon"],
                                      width: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      children: [
                                        Apptext(
                                          data: "Sunset",
                                          color: Colors.white,
                                          fw: FontWeight.bold,
                                          size: 15,
                                          ff: "Roboto",
                                        ),
                                        Apptext(
                                          data: "$formattedSunset PM",
                                          color: Colors.white,
                                          fw: FontWeight.w300,
                                          size: 12,
                                          ff: "Roboto",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
