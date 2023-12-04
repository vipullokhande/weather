import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/resources/weather_api.dart';

import 'manage_cities_page.dart';

class WeatherSCreen extends StatefulWidget {
  final String city;
  const WeatherSCreen({super.key, this.city = 'Mumbai'});

  @override
  State<WeatherSCreen> createState() => _WeatherSCreenState();
}

class _WeatherSCreenState extends State<WeatherSCreen> {
  bool isLoading = false;
  late Model data;
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  getWeather() async {
    setState(() {
      isLoading = true;
    });
    data = await WeatherApi().getData(widget.city);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/weather.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        height: double.maxFinite,
        width: double.maxFinite,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.cityName),
                        const Icon(
                          Icons.edit_location,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Get.to(const ManageCitiesPage());
                        },
                        icon: const Icon(
                          Icons.business_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          data.temp,
                          style: const TextStyle(
                            fontSize: 100,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              ' °C',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                '   ${data.weatherName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
