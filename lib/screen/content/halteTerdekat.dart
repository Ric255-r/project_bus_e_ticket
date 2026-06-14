import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

import 'pesanTiket.dart';

class Halteterdekat extends StatefulWidget {
  const Halteterdekat({super.key});

  @override
  State<Halteterdekat> createState() => _HalteterdekatState();
}

class _HalteterdekatState extends State<Halteterdekat> {
  MapController? _mapController;
  GeoPoint? _userPoint;
  List<Halte> _haltes = const [];
  Halte? _selectedHalte;
  RoadInfo? _roadInfo;
  String? _errorMessage;
  bool _isLoadingLocation = true;
  bool _isDrawingRoute = false;
  bool _mapIsReady = false;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Aktifkan layanan lokasi (GPS) terlebih dahulu.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Izin lokasi ditolak.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi ditolak permanen. Aktifkan izin lokasi dari pengaturan aplikasi.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _loadUserLocation() async {
    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
        _errorMessage = null;
      });
    }

    try {
      final position = await _determinePosition();
      final userPoint = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final haltes = await _fetchNearbyHaltes(position);

      if (!mounted) return;
      setState(() {
        _userPoint = userPoint;
        _haltes = haltes;
        _mapController ??= MapController.withPosition(initPosition: userPoint);
        _isLoadingLocation = false;
      });

      if (_mapIsReady) {
        await _showMapPoints();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<List<Halte>> _fetchNearbyHaltes(Position position) async {
    final response = await Dio().get(
      '${myIpAddr()}/halte-terdekat',
      queryParameters: {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'radius': 10000,
        'limit': 20,
      },
      options: Options(receiveTimeout: const Duration(seconds: 30)),
    );

    final items = response.data['items'] as List<dynamic>? ?? const [];
    return items.map((rawItem) {
      final item = rawItem as Map<String, dynamic>;
      final operatorName = item['operator']?.toString();
      final name = item['name']?.toString() ?? 'Halte tanpa nama';
      final searchableOperator = '${operatorName ?? ''} $name'.toLowerCase();
      final ticketValue = searchableOperator.contains('damri')
          ? 'Damri'
          : searchableOperator.contains('ats')
              ? 'ATS'
              : null;
      return Halte(
        name: name,
        ticketValue: ticketValue,
        imageAsset: 'assets/images/halte.png',
        point: GeoPoint(
          latitude: (item['latitude'] as num).toDouble(),
          longitude: (item['longitude'] as num).toDouble(),
        ),
      );
    }).toList();
  }

  Future<void> _showMapPoints() async {
    final controller = _mapController;
    final userPoint = _userPoint;
    if (controller == null || userPoint == null) return;

    await controller.removeAllCircle();
    await controller.drawCircle(
      CircleOSM(
        key: 'user-radius',
        centerPoint: userPoint,
        radius: 180,
        color: Colors.blue.withValues(alpha: 0.12),
        borderColor: Colors.blue,
        strokeWidth: 1,
      ),
    );

    for (final halte in _haltes) {
      await controller.addMarker(
        halte.point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.directions_bus, color: Colors.red, size: 46),
        ),
      );
    }
    await controller.moveTo(userPoint, animate: true);
    await controller.setZoom(zoomLevel: 15);
  }

  Future<void> _centerOnUser() async {
    if (_userPoint == null) {
      await _loadUserLocation();
      return;
    }
    await _mapController?.moveTo(_userPoint!, animate: true);
    await _mapController?.setZoom(zoomLevel: 16);
  }

  Future<void> _drawRoute(Halte halte) async {
    final controller = _mapController;
    final userPoint = _userPoint;
    if (controller == null || userPoint == null || _isDrawingRoute) return;

    setState(() {
      _selectedHalte = halte;
      _roadInfo = null;
      _isDrawingRoute = true;
    });

    try {
      await controller.clearAllRoads();
      final road = await controller.drawRoad(
        userPoint,
        halte.point,
        roadType: RoadType.car,
        roadOption: const RoadOption(
          roadColor: Colors.blue,
          roadWidth: 10,
          zoomInto: true,
        ),
      );
      if (!mounted) return;
      setState(() => _roadInfo = road);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Rute gagal dimuat. Periksa koneksi internet lalu coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isDrawingRoute = false);
    }
  }

  double _distanceTo(Halte halte) {
    final userPoint = _userPoint;
    if (userPoint == null) return 0;
    return Geolocator.distanceBetween(
          userPoint.latitude,
          userPoint.longitude,
          halte.point.latitude,
          halte.point.longitude,
        ) /
        1000;
  }

  String _routeSummary(Halte halte) {
    if (_selectedHalte == halte && _isDrawingRoute) return 'Menghitung rute...';
    if (_selectedHalte == halte && _roadInfo != null) {
      final distance = _roadInfo!.distance?.toStringAsFixed(1) ?? '-';
      final minutes = ((_roadInfo!.duration ?? 0) / 60).ceil();
      return '$distance km - sekitar $minutes menit';
    }
    return 'Sekitar ${_distanceTo(halte).toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halte Terdekat')),
      body: _buildBody(),
      floatingActionButton: _mapController == null
          ? null
          : FloatingActionButton(
              onPressed: _centerOnUser,
              tooltip: 'Posisi saya',
              child: const Icon(Icons.my_location),
            ),
    );
  }

  Widget _buildBody() {
    if (_isLoadingLocation) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 56, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadUserLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: OSMFlutter(
            controller: _mapController!,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(Icons.my_location, color: Colors.blue, size: 44),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(Icons.navigation, color: Colors.blue, size: 44),
                ),
              ),
              zoomOption: const ZoomOption(
                initZoom: 15,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1,
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.blue,
                roadWidth: 10,
              ),
              showContributorBadgeForOSM: true,
            ),
            onMapIsReady: (isReady) async {
              if (!isReady) return;
              _mapIsReady = true;
              await _showMapPoints();
            },
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.32,
          minChildSize: 0.14,
          maxChildSize: 0.65,
          snap: true,
          builder: (context, scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pilih halte tujuan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (final halte in _haltes) _buildHalteCard(halte),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHalteCard(Halte halte) {
    final selected = _selectedHalte == halte;
    return Card(
      color: selected ? Colors.blue.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black12,
                width: 76,
                height: 76,
                child: Image.asset(halte.imageAsset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    halte.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(_routeSummary(halte)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed:
                            _isDrawingRoute ? null : () => _drawRoute(halte),
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Lihat rute'),
                      ),
                      if (halte.ticketValue != null)
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Pesantiket(
                                  existsHalte: halte.ticketValue!,
                                ),
                              ),
                            );
                          },
                          child: const Text('Pesan tiket'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Halte {
  const Halte({
    required this.name,
    this.ticketValue,
    required this.imageAsset,
    required this.point,
  });

  final String name;
  final String? ticketValue;
  final String imageAsset;
  final GeoPoint point;
}
