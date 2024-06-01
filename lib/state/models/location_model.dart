// location_model.dart

// Define the LocationModel class which represents the structure of location data
class LocationModel {
  // Field to store the location name
  String location;

  // Field to store the latitude of the location
  double latitude;

  // Field to store the longitude of the location
  double longitude;

  /// Constructs a new instance of [LocationModel].
  /// The [location] parameter is required and represents the name of the location.
  /// The [latitude] parameter is required and represents the latitude of the location.
  /// The [longitude] parameter is required and represents the longitude of the location.
  LocationModel(
      {required this.location,
      required this.latitude,
      required this.longitude});

  /// Constructs a new instance of [LocationModel] from a Map.
  /// This constructor is useful for converting JSON or Firestore data to [LocationModel] instances.
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      location: map['location'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  /// Converts a [LocationModel] instance to a Map.
  /// This method is useful for converting [LocationModel] instances to JSON or Firestore data.
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
