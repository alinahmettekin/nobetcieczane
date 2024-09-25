import 'package:eczanemnerede/view/map/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? currenPosition;
  late final readingProvider = Provider.of<MapViewModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Text('Nöbetçi Eczaneler'),
              ),
              Tab(
                child: Text('Tüm Eczaneler'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNPharmacy(),
            const Center(
              child: Text('Tüm Eczaneler gösterimi şu an desteklenmemektedir'),
            )
          ],
        ),
      ),
    );
  }

  Location location = Location();

  void getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    currenPosition = LatLng(locationData.latitude!, locationData.longitude!);

    await readingProvider.getNearPharmacy(currenPosition!);

    setState(() {});
  }

  Widget _buildNPharmacy() {
    return currenPosition == null
        ? const Center(
            child: Text('Loading'),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currenPosition!,
              zoom: 13,
            ),
            markers: Provider.of<MapViewModel>(context, listen: false).pharmaciesMarkers,
          );
  }
}
