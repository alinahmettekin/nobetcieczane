import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nobetcieczane/core/components/custom_pharmacy_tile.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
import 'package:nobetcieczane/view/map/map_view_model.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? currentPosition;
  late final readingProvider = Provider.of<MapViewModel>(context, listen: false);

  _setSelectedPharmacy(int pharmacyId, List<Pharmacy> pharmacies) {
    if (pharmacyId == 0) {
      return;
    } else {
      final pharmacy = pharmacies.firstWhere((e) => e.pharmacyId == pharmacyId);
      _showDropdownPharmacy(pharmacy);
    }
  }

  _showDropdownPharmacy(Pharmacy pharmacy) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              CustomPharmacyTile(pharmacy: pharmacy),
            ],
          ),
        );
      },
    );
  }

  _loadNearPharmaciesMarkers() async {
    readingProvider.nearPharmaciesMarkers.clear();
    for (var pharmacy in readingProvider.nearPharmacies) {
      readingProvider.nearPharmaciesMarkers.add(
        Marker(
          markerId: MarkerId('${pharmacy.pharmacyId}'),
          position: LatLng(pharmacy.latitude!, pharmacy.longitude!),
          icon: AssetMapBitmap(
            'assets/icon/pharmacy_icon.png',
            bitmapScaling: MapBitmapScaling.auto,
            width: 40,
            height: 40,
          ),
          onTap: () {
            _setSelectedPharmacy(pharmacy.pharmacyId ?? 0, readingProvider.nearPharmacies);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
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
    currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

    await readingProvider.getNearPharmacy(currentPosition!);
    if (readingProvider.nearPharmacies.isNotEmpty) {
      await _loadNearPharmaciesMarkers();
    }

    setState(() {});
  }

  Widget _buildMapPharmacy() {
    return currentPosition == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              Text(LocaleKeys.loading.tr())
            ],
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition!,
              zoom: 13,
            ),
            myLocationEnabled: true,
            markers: Provider.of<MapViewModel>(context, listen: false).nearPharmaciesMarkers,
          );
  }

  Widget _buildListPharmacy() {
    return currentPosition == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                LocaleKeys.loading.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView.builder(
              itemCount: readingProvider.nearPharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = readingProvider.nearPharmacies[index];
                return CustomPharmacyTile(pharmacy: pharmacy);
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text(
            LocaleKeys.duty_pharmacies_map.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text(LocaleKeys.map_text.tr()),
              ),
              Tab(
                child: Text(LocaleKeys.list_text.tr()),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildMapPharmacy(),
            _buildListPharmacy(),
          ],
        ),
      ),
    );
  }
}
