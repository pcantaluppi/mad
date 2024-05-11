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
  // todo: read from state
  final LatLng _start = const LatLng(47.5596, 7.5886); // Basel, Switzerland
  final LatLng _end = const LatLng(47.9990, 7.8421); // Freiburg, Germany
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Future<String>? _styleFuture;

  @override
  void initState() {
    super.initState();
    _styleFuture = _loadMapStyle();
    _addMarker();
    _createRoute();
  }

  Future<String> _loadMapStyle() async {
    return await rootBundle.loadString('assets/map/style.json');
  }

  void _addMarker() {
    _markers.add(
      Marker(
        // todo: read from state
        markerId: const MarkerId('basel'),
        position: _start,
        infoWindow: const InfoWindow(
            title: 'Current Location',
            // todo: read from state
            snippet: 'Basel, Switzerland'),
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
  }

  void _updateCameraBounds() {
    final LatLngBounds bounds = LatLngBounds(
      // todo: add bounds dynamically
      southwest: const LatLng(47.5596, 7.5886),
      northeast: const LatLng(47.9990, 7.8421),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _styleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _onMapCreated(controller);
              // todo: remove deprecated method
              controller.setMapStyle(snapshot.data);
              _updateCameraBounds();
            },
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
