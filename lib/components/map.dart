import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A page that displays a map.
///
/// This page is used to show a map and related information for a specific train.
class MapPage extends StatefulWidget {
  final int trainId;

  /// Creates a new instance of [MapPage].
  ///
  /// The [trainId] parameter is required and specifies the ID of the train.
  const MapPage({super.key, required this.trainId});

  @override
  State<MapPage> createState() => _MapPageState();
}

/// The state class for the MapPage widget.
class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _start = const LatLng(47.5596, 7.5886); // Basel, Switzerland
  final LatLng _end = const LatLng(47.9990, 7.8421); // Freiburg, Germany
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _mapStyle;
  bool _isStyleLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMapStyle().then((_) {
      _isStyleLoaded = true;
      setState(() {});
    });
    _addMarker();
    _createRoute();
  }

  /// Loads the map style from the assets.
  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map/style.json');
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
    List<LatLng> routePoints = [
      _start,
      const LatLng(47.7410, 7.6200), // Weil am Rhein, Germany
      const LatLng(47.8060, 7.6600), // Neuenburg am Rhein, Germany
      const LatLng(47.8750, 7.7190), // Müllheim, Germany
      _end
    ];

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
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Transport 1',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _isStyleLoaded
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
