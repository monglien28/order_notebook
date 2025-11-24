import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_notebook/map_widget/map_riverpod.dart';

class SelectLocationPage extends ConsumerStatefulWidget {
  final void Function(LatLng location) onLocationSelected;

  const SelectLocationPage({super.key, required this.onLocationSelected});

  @override
  ConsumerState<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends ConsumerState<SelectLocationPage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  late CameraPosition initialPosition;

  @override
  void initState() {
    final location = ref.read(locationProvider);
    if (location != null) {
      initialPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 16,
      );
    } else {
      initialPosition = CameraPosition(
        target: LatLng(26.873601, 75.776285), // India center
        zoom: 14,
      );
    }
    super.initState();
  }

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
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
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
        ),
        SizedBox(height: 7),
        // Current Location Button
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.brown.withAlpha(30)),
          ),
          onPressed: goToCurrentLocation,
          label: Text(
            'Go to current location',
            style: TextStyle(color: Colors.blue ,textBaseline: TextBaseline.alphabetic),
          ),
          icon: Icon(Icons.my_location, color: Colors.blue),
        ),
        SizedBox(height: 20),

        // Confirm Location Button
        if (selectedLocation != null)
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Confirm Location"),
            onPressed: () {
              widget.onLocationSelected(selectedLocation!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
          ),
      ],
    );
  }
}
