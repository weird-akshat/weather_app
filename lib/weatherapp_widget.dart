import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additonal_info_cell.dart';
import 'package:weather_app/hourly_weather_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherAppWidget extends StatefulWidget {
  WeatherAppWidget({Key? key}) : super(key: key);
  @override
  State<WeatherAppWidget> createState() => _WeatherAppWidget();
}

class _WeatherAppWidget extends State<WeatherAppWidget> {
  String temp = '0';
  bool isLoading = false;
  final String apiId = dotenv.env['APID'].toString();

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Udupi';

    final res = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiId'));
    final data = jsonDecode(res.body);
    if (data['cod'] != '200') {
      throw data['message'];
    }
    return data;
  }

  late String string;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  String kelvinToCelsius(String kelvin) {
    double celsius = double.parse(kelvin) - 273.15;
    return celsius.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getCurrentWeather();
                });
              },
              icon: Icon(Icons.refresh))
        ],
        title: Text(
          'Weather App',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final temp = (currentWeatherData['main']['temp'].toString());
          final sky = currentWeatherData['weather'][0]['main'];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Card(
                        semanticContainer: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 20,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                            ),
                            Text(
                              '${kelvinToCelsius(temp)}°C',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: sky == 'Clouds' || sky == 'Rain'
                                  ? Icon(Icons.cloud, size: 70)
                                  : Icon(Icons.sunny, size: 70),
                            ),
                            Text(
                              sky,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                ),
                Text(' Weather Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         hourlyWeatherCards(
                //             data['list'][i + 1]['main']['temp'].toString(),
                //             data['list'][i + 1]['dt_txt'],
                //             currentWeatherData['weather'][0]['main'] ==
                //                         'Clouds' ||
                //                     currentWeatherData['weather'][0]['main'] ==
                //                         'Rain'
                //                 ? Icons.cloud
                //                 : Icons.sunny),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);
                        final hourweather = data['list'][index + 1];
                        return hourlyWeatherCards(
                            '${kelvinToCelsius(data['list'][index + 1]['main']['temp'].toString())}°C',
                            DateFormat.j().format(time),
                            hourweather['weather'][0]['main'] == 'Clouds' ||
                                    hourweather['weather'][0]['main'] == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny);
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                ),
                Text(
                  ' Additional Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoCell(Icons.water_drop, 'Humidity',
                          data['list'][0]['main']['humidity'].toString()),
                      AdditionalInfoCell(Icons.air, 'Wind Speed',
                          data['list'][0]['wind']['speed'].toString()),
                      AdditionalInfoCell(Icons.beach_access, 'Pressure',
                          data['list'][0]['main']['pressure'].toString()),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
