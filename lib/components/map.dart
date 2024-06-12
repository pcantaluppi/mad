// map.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  LatLng _start = const LatLng(47.5596, 7.5886); // Basel, Switzerland
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadMapStyle();
    _addMarker();
    _createRoute();
  }

  /// Loads the map style from the assets.
  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map/style.json');
    setState(() {});
  }

  /// Checks for location permissions and requests them if not granted.
  void _checkPermissions() async {
    if (await Permission.location.isGranted) {
      // Permissions are already granted, do nothing
    } else {
      // Request permissions
      await Permission.location.request();
    }
  }

  /// Adds a marker to the map.
  void _addMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('basel'),
        position: _start,
        infoWindow: const InfoWindow(
            title: 'Current Location', snippet: 'Basel, Switzerland'),
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

    _start = routePoints.first;

    final Polyline route = Polyline(
      polylineId: const PolylineId('route'),
      visible: true,
      points: routePoints,
      width: 5,
      color: const Color.fromARGB(255, 148, 165, 179),
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
      southwest: const LatLng(47.5596, 7.5886),
      northeast: const LatLng(47.9990, 7.8421),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    _checkPermissions();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Transport ${widget.trainId}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _mapStyle != null
            ? GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _start,
                  zoom: 8.0,
                ),
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
