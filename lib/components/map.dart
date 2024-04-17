import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  // todo: read from state
  final LatLng _start = const LatLng(47.5596, 7.5886); // Basel, Switzerland
  final LatLng _end = const LatLng(47.9990, 7.8421); // Freiburg, Germany
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _addMarker();
    _createRoute();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map/style.json');
    setState(() {});
  }

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

  void _createRoute() {
    List<LatLng> routePoints = [
      _start,
      // todo: add points dynamically
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_mapStyle != null) {
      mapController.setMapStyle(_mapStyle);
    }
    _updateCameraBounds();
  }

  void _updateCameraBounds() {
    final LatLngBounds bounds = LatLngBounds(
      southwest: const LatLng(47.5596, 7.5886),
      northeast: const LatLng(47.9990, 7.8421),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    // todo: convert it to a widget
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Train 123456789'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _start,
            zoom: 8.0,
          ),
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          style: _mapStyle, // Apply the style directly here
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
        ),
      ),
    );
  }
}
