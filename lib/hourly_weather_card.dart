import "package:flutter/material.dart";

class hourlyWeatherCards extends StatelessWidget {
  const hourlyWeatherCards(
    this.temperature,
    this.time,
    this.icon, {
    super.key,
  });
  final String temperature;
  final String time;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 123,
      child: Card(
        elevation: 10,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            time,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.all(5),
          ),
          Icon(
            size: 40,
            icon,
          ),
          Container(
            padding: EdgeInsets.all(5),
          ),
          Text(
            temperature,
            style: (TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }
}
