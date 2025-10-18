import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? mapController;
  LatLng _selectedLatLng = const LatLng(26.873601, 75.776285); // Default: Jaipur

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLatLng = position;
    });
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  void _onConfirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${_selectedLatLng.latitude}, ${_selectedLatLng.longitude}',
        ),
      ),
    );

    // You can return it or send it to your backend here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            onTap: _onMapTapped,
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('selected'),
                position: _selectedLatLng,
                draggable: true,
                onDragEnd: (pos) => setState(() => _selectedLatLng = pos),
              ),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onConfirm,
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
