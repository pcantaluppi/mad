// location_model.dart

// Define the LocationModel class which represents the structure of location data
class LocationModel {
  // Field to store the location name
  String location;

  // Field to store the latitude of the location
  double lat;

  // Field to store the longitude of the location
  double lon;

  /// Constructs a new instance of [LocationModel].
  /// The [location] parameter is required and represents the name of the location.
  /// The [lat] parameter is required and represents the latitude of the location.
  /// The [lon] parameter is required and represents the longitude of the location.
  LocationModel({required this.location, required this.lat, required this.lon});

  /// Constructs a new instance of [LocationModel] from a Map.
  /// This constructor is useful for converting JSON or Firestore data to [LocationModel] instances.
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      location: map['location'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }

  /// Converts a [LocationModel] instance to a Map.
  /// This method is useful for converting [LocationModel] instances to JSON or Firestore data.
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'lat': lat,
      'lon': lon,
    };
  }
}
