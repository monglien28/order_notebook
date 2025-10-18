import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocationPage extends StatefulWidget {
  final void Function(LatLng location) onLocationSelected;

  const SelectLocationPage({super.key, required this.onLocationSelected});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(26.873601, 75.776285), // India center
    zoom: 14,
  );

  // Get current location
  Future<void> goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission permanently denied. Please enable it.',
          ),
        ),
      );
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    // Move map to current location
    mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

    // Set as selected location
    setState(() {
      selectedLocation = currentLatLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          webCameraControlEnabled: false,
          onMapCreated: (controller) => mapController = controller,
          initialCameraPosition: initialPosition,
          onTap: (LatLng position) {
            setState(() => selectedLocation = position);
          },
          markers: {
            if (selectedLocation != null)
              Marker(
                markerId: const MarkerId("selected"),
                position: selectedLocation!,
              ),
          },
        ),

        // Current Location Button
        Positioned(
          right: 5,
          bottom: 120,
          child: FloatingActionButton(backgroundColor: Colors.white,
            shape: CircleBorder(),
            onPressed: goToCurrentLocation,
            child: const Icon(Icons.my_location ,color: Colors.blue,),
          ),
        ),

        // Confirm Location Button
        if (selectedLocation != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
              onPressed: () {
                widget.onLocationSelected(selectedLocation!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
      ],
    );
  }
}
