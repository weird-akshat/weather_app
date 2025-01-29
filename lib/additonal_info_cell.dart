import 'package:flutter/material.dart';

class AdditionalInfoCell extends StatelessWidget {
  const AdditionalInfoCell(
    this.icon,
    this.string,
    this.percentage, {
    super.key,
  });
  final IconData icon;
  final String string;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(icon),
        Text(
          string,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(percentage)
      ],
    );
  }
}
