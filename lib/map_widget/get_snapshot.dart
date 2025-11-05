String getStaticMapUrl(double lat, double lng) {
  const apiKey = "AIzaSyAaUmzOqYKQZCwwH8F44QuO53vQ6wWNbhw"; // Google Maps Static API key
  const zoom =17;
  const size = "400x400"; // Width x Height in pixels
  const markerColor = "red";

  return "https://maps.googleapis.com/maps/api/staticmap?"
      "center=$lat,$lng"
      "&zoom=$zoom"
      "&size=$size"
      "&markers=color:$markerColor|$lat,$lng"
      "&key=$apiKey";
}
