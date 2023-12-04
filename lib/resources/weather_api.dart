import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/manage_cities_page.dart';

class WeatherApi {
  Future<Model> getData(String city) async {
    // var ak =
    //     'https:/api.openweathermap.org/data/2.5/forecast?id=1275339&appid=07fa88dbf4794d7273b2b60406b58e06';
    var apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=07fa88dbf4794d7273b2b60406b58e06';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      var data = await jsonDecode(response.body);
      return Model(
        cityName: data['name'],
        temp: (data['main']['temp'].toInt() - 273.toInt()).toString(),
        weatherName: data['weather'][0]['description'],
      );
      // ignore: empty_catches
    } catch (e) {}
    return Model(cityName: '', temp: '', weatherName: '');
  }
}
