import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/manage_cities_page.dart';
import 'package:weather/secrets/secrets.dart';

class WeatherApi {
  Future<Model> getData(String city) async {
    try {
      final response = await http.get(Uri.parse(apiUrl(city)));
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
