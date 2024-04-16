import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(47.547805680410434, 7.5827125296898545);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _addMarker();
    _createRoute();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('center_marker'),
        position: _center,
        infoWindow: const InfoWindow(
          title: 'Train 1234567890',
          snippet: 'Current location.',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  void _createRoute() {
    final List<LatLng> routeCoords = [
      const LatLng(46.2932, 7.8810), // Visp, Switzerland
      const LatLng(47.5596, 7.5886), // Basel, Switzerland
      const LatLng(48.7758, 9.1829), // Stuttgart, Germany
      const LatLng(50.1109, 8.6821), // Frankfurt, Germany
    ];

    final Polyline route = Polyline(
      polylineId: const PolylineId('route1'),
      visible: true,
      points: routeCoords,
      width: 6,
      color: Colors.blue,
    );
    setState(() {
      _polylines.add(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 212, 224, 230),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Demo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
        ),
      ),
    );
  }
}
