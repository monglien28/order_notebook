import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

/// State class to hold latitude and longitude
class UserLocation {
  final double latitude;
  final double longitude;
  const UserLocation(this.latitude, this.longitude);
}

/// Notifier to handle location fetching and storage
class LocationNotifier extends StateNotifier<UserLocation?> {
  LocationNotifier() : super(null);

  /// Request permission and fetch current location
  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Fetch current position
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Update state
    state = UserLocation(position.latitude, position.longitude);
  }
}

/// Global provider
final locationProvider = StateNotifierProvider<LocationNotifier, UserLocation?>(
  (ref) => LocationNotifier(),
);
