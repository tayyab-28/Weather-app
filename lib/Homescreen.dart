import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/forecastcard.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String cityName = 'pakki khoi';
  String icondata = '';
  String temperature = '';
  String weatherCondition = '';
  String windSpeed = '';
  String humidity = '';
  bool isLoading = false;
  List<dynamic> forecastdetails = [];

  final String apiKey = 'a8a07acd52d1415898893827241408';

  TextEditingController cityController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchWeather(cityName);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        cityName = data['location']['name'];
        temperature = '${data['current']['temp_c']}°C';
        weatherCondition = data['current']['condition']['text'];
        windSpeed = '${data['current']['wind_kph']} km/h';
        humidity = '${data['current']['humidity']}%';
        forecastdetails = data['forecast']['forecastday'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        temperature = 'Error';
        weatherCondition = 'Could not fetch weather data';
      });
    }
  }

  Future<Position> fetchweatherlocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffbcd3d4),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: cityController,

                      decoration: InputDecoration(

                        hintText: 'Enter city name',
                        filled: true,
                        fillColor: Colors.white30,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            fetchWeather(cityController.text);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    cityName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20,letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              temperature,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 50),
                            ),
                            Text(
                              weatherCondition,
                              style: const TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.wind_power_outlined),
                                     SizedBox(width: 10,),
                                    Text(
                                      windSpeed,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Icon(Icons.water_drop_outlined,size: 28.0,),
                                    SizedBox(width: 5,),
                                    Text(humidity,style: TextStyle(fontSize: 22)),
                                  ]
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [Icon(Icons.wb_sunny)],
                                )
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_rounded),
                                  SizedBox(width: 10),
                                  Text(
                                    'Weekly Forecast',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            forecastdetails.isEmpty
                                ? const Text('error')
                                : Column(
                                    children: forecastdetails.map((day) {
                                      return ForecastCard(
                                        icondata: day['day']['condition']
                                            ['icon'],
                                        date: day['date'],
                                        weatherCondtion: day['day']['condition']
                                            ['text'],
                                        temperature:
                                            '${day['day']['avgtemp_c']}°C',
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
