import 'dart:convert';


import 'package:geocoding/geocoding.dart';
import 'package:www/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    print(cityName);
    print('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
  }
  else{
    throw Exception('Failed to load weather data');
}
  }
 Future<String> getCurrentCity() async{
  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  String? city;
// is device ios
  if (placemarks[0].locality != ''){
    city = placemarks[0].locality;
  }
  else{
    city = placemarks[0].subAdministrativeArea;
  }

  

  print(placemarks[0]);

  return city ?? "";
 }


}