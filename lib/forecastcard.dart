import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String icondata;
  final String date;
  final String weatherCondtion;
  final String temperature;

  const ForecastCard({
    required this.icondata,
    required this.date,
    required this.weatherCondtion,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Image.network(
                'http:${icondata}'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weatherCondtion,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  temperature,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}