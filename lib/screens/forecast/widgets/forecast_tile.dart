import 'package:flutter/material.dart';
import '../../../models/forecast_model.dart';

class ForecastTile extends StatelessWidget {
  final ForecastItem item;

  const ForecastTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          'https://openweathermap.org/img/wn/${item.icon}.png',
          width: 50,
        ),
        title: Text(
          _formatDateTime(item.dateTime),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.description.toUpperCase()),
        trailing: Text(
          '${item.main.temp.round()}°C',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _formatDateTime(String dtTxt) {
    // Basic formatting: extracts date and time from "yyyy-MM-dd HH:mm:ss"
    final dateTime = DateTime.parse(dtTxt);
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return '${days[dateTime.weekday - 1]} ${dateTime.day}/${dateTime.month} - ${dateTime.hour}h';
  }
}
