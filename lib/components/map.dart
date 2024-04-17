import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  // TODO: Read from state
  final LatLng _start = const LatLng(47.5596, 7.5886); // Basel, Switzerland
  // TODO: Read from state
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
        markerId: const MarkerId('basel'), // TODO: Read from state
        position: _start,
        infoWindow: const InfoWindow(
            title: 'Current Location',
            snippet: 'Basel, Switzerland'), // TODO: Read from state
      ),
    );
  }

  void _createRoute() {
    List<LatLng> routePoints = [
      _start,
      // TODO: Add points dynamically
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
    return GoogleMap(
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
    );
  }
}
