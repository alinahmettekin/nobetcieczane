import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/constants/image_constants.dart';
import 'package:nobetcieczane/core/helper/ad_mob_helper.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/custom_pharmacy_card.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/loader.dart';

/// MapView is a StatefulWidget that contains the map view.
class MapView extends StatefulWidget {
  /// MapView constructor
  const MapView({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  /// latitude usign for the GoogleMap
  final double latitude;

  /// longitude usign for the GoogleMap
  final double longitude;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon(targetWidth: 48);
  }

  /// Loads the pharmacy marker asset and resizes it to [targetWidth] logical
  /// pixels. Using dart:ui resize avoids the iOS crash that happens when a
  /// large PNG is passed directly to BitmapDescriptor.fromAssetImage.
  Future<void> _loadMarkerIcon({int targetWidth = 80}) async {
    try {
      final data = await rootBundle.load(ImageConstants.pharmacyIcon);
      final bytes = data.buffer.asUint8List();

      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetWidth,
      );
      final frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null && mounted) {
        setState(() {
          _markerIcon = BitmapDescriptor.bytes(
            byteData.buffer.asUint8List(),
          );
        });
      }
    } on Exception {
      // Fallback: keep the default red marker
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.map_app_bar_title.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorSchemeLight.instance.red,
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeGetNearPharmaciesFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeGetNearPharmaciesFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeGetNearPharmaciesSuccess) {
              return SafeArea(
                child: Stack(
                  children: [
                    _buildGoogleMap(context, state),
                    _buildAdMobBanner(),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Loader(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildGoogleMap(
    BuildContext context,
    HomeGetNearPharmaciesSuccess state,
  ) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      ),
      onMapCreated: (controller) {},
      myLocationEnabled: true,
      markers: state.pharmacies
          .map(
            (pharmacy) => Marker(
              markerId: MarkerId(pharmacy.pharmacyId.toString()),
              position: LatLng(pharmacy.latitude!, pharmacy.longitude!),
              infoWindow: InfoWindow(
                title: pharmacy.pharmacyName,
                snippet: pharmacy.distanceKm == null
                    ? ''
                    : '${pharmacy.distanceKm!.toStringAsFixed(2)} km',
              ),
              icon: _markerIcon,
              onTap: () => _buildSelectionCard(context, pharmacy),
            ),
          )
          .toSet(),
    );
  }

  Future<dynamic> _buildSelectionCard(BuildContext context, Pharmacy pharmacy) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).colorScheme.surface
                : Colors.white, // Tema uyumu
            borderRadius: BorderRadius.circular(15),
          ),
          height: 275,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // Tema uyumlu Card
                  CustomPharmacyCard(
                    pharmacy: pharmacy,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdMobBanner() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AdMobBannerWidget(
        type: BannerAdType.secondBanner,
      ),
    );
  }
}
