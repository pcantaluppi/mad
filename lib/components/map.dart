// map.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:train_tracker/components/common/custom_appbar.dart';
import 'package:train_tracker/state/location_provider.dart';
import 'package:train_tracker/state/models/location_model.dart';

/// A page that displays a map.
/// This page is used to show a map and related information for a specific train.
class MapPage extends StatefulWidget {
  final int trainId;

  /// Creates a new instance of [MapPage].
  /// The [trainId] parameter is required and specifies the ID of the train.
  const MapPage({super.key, required this.trainId});

  @override
  State<MapPage> createState() => _MapPageState();
}

/// The state class for the MapPage widget.
class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late LocationModel _start;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _createRoute();
    _addMarker();
  }

  /// Loads the map style from the assets.
  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map/style.json');
    setState(() {});
  }

  /// Adds a marker to the map.
  void _addMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('basel'),
        position: LatLng(_start.latitude, _start.longitude),
        infoWindow: InfoWindow(
            title: 'Current Location', snippet: _start.location),
      ),
    );
  }

  /// Creates a route polyline on the map.
  void _createRoute() {
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    List<LocationModel> locations = locationProvider.locations;
    List<LatLng> routePoints = locations.map((LocationModel x) {
      return LatLng(x.latitude, x.longitude);
    }).toList();

    _start = locations.first;

    final Polyline route = Polyline(
      polylineId: const PolylineId('route'),
      visible: true,
      points: routePoints,
      width: 5,
      color: Colors.white,
    );
    _polylines.add(route);
  }

  /// Callback when the map is created.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_mapStyle != null) {
      // ignore: deprecated_member_use
      mapController.setMapStyle(_mapStyle);
    }
    _updateCameraBounds();
  }

  /// Updates the camera bounds of the map.
  void _updateCameraBounds() {
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(_start.latitude, _start.longitude),
      northeast: LatLng(_start.latitude + 0.4, _start.longitude + 0.2),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

@override
Widget build(BuildContext context) {
  _checkPermissions();
  return Scaffold(
    backgroundColor: Colors.transparent, // Set background color to transparent
    body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(_start.latitude, _start.longitude),
            zoom: 8.0,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(title: 'Transport ${widget.trainId}'),
          ),
        ],
      ),
    );
  }
}
