import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/weather_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  void _updateMarkers() {
    final weather = context.read<WeatherProvider>().weather;
    if (weather != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(weather.coord.lat, weather.coord.lon),
            infoWindow: InfoWindow(
              title: weather.cityName,
              snippet: '${weather.temp.round()}°C - ${weather.description}',
            ),
          ),
        );
      });
    }
  }

  void _onMapTap(LatLng position) {
    context.read<WeatherProvider>().fetchWeatherByCoordinates(
      position.latitude,
      position.longitude,
    );
    
    // We update markers again after weather is fetched (handled via provider check or direct update)
    // For simplicity, we can just clear and add new one
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final weather = context.read<WeatherProvider>().weather;
    final initialPos = weather != null 
        ? LatLng(weather.coord.lat, weather.coord.lon)
        : const LatLng(14.7167, -17.4677); // Default Dakar

    return Scaffold(
      appBar: AppBar(title: const Text('Carte Météo')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initialPos, zoom: 10),
        markers: _markers,
        onTap: _onMapTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
