import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/weatherapp_widget.dart';

void main() async {
  try {
    // print("Loading .env file...");
    await dotenv.load();
    // print("Loaded .env: ${dotenv.env}");
  } catch (e) {
    // print("Error loading .env file: $e");
  }
  // Load environment variables

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "WeatherApp",
        theme: ThemeData.light(useMaterial3: true),
        home: WeatherAppWidget());
  }
}
