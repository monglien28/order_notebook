import 'dart:async';
import 'package:http/http.dart' as http;

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  //  final apiUrl = Uri.http('localhost:8013', 'GetDtr');

  final Uri apiUrl = Uri.https(
    'maps.googleapis.com',
    '/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyAaUmzOqYKQZCwwH8F44QuO53vQ6wWNbhw',
  );


  try {
    // Send the GET request
    final http.Response response = await http
        .get(
          apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception(response.body);
    } else if (response.statusCode >= 500) {
      throw Exception(response.body);
    } else {
      throw Exception('Something went wrong !!!');
    }
  } catch (e) {
    rethrow;
  }
}
