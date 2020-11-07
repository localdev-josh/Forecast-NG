import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_interview/models/weatherModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class WeatherBloc extends BlocBase {
  final weatherStream = BehaviorSubject<WeatherModel>();
  WeatherModel _weatherStore;
  UserCredential user;
  String notFound = "";
  String state = "";

  //output
  Stream<WeatherModel> get fetchWeather =>
      weatherStream.stream;

  WeatherBloc() {
    state = "Boston";
    getWeather(state);
  }

  Future getWeather(String state) async {
    return http.get("http://api.openweathermap.org/data/2.5/weather?q=" + state + "&appid=" + "5b77b6833b60ae6029eb329d75426567").then((data) {
      if(data.statusCode == 200) {
        final responseData = json.decode(data.body);
        _weatherStore = WeatherModel.fromJson(responseData);
        weatherStream.sink.add(_weatherStore);
      } else if(data.statusCode == 404) {
        notFound = "city not found";
      } else {
        notFound = "Error occurred";
      }
    });
  }

  Future initialSharedWeatherPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userMail", user.user.email);
    await prefs.setInt("initScreen", 1);
  }

  Future initialSharedLoginPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("initScreen", 0);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    weatherStream.close();
    super.dispose();
  }
}
