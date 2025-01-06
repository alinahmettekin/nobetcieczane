import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/button/call_button.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/button/navigate_button.dart';

/// CustomPharmacyCard is a StatelessWidget
/// that contains the custom pharmacy card.
class CustomPharmacyCard extends StatelessWidget {
  /// CustomPharmacyCard constructor
  const CustomPharmacyCard({required this.pharmacy, super.key});

  /// Pharmacy is a final variable of type Pharmacy
  final Pharmacy pharmacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo/app_logo.png',
                width: 30,
                height: 30,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  pharmacy.pharmacyName ?? LocaleKeys.null_pharmacy_name.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pharmacy.address ?? LocaleKeys.null_pharmacy_address.tr(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 10,
              ),
              Text(
                pharmacy.phone ?? LocaleKeys.null_pharmacy_phone.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            pharmacy.directions ?? '',
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            pharmacy.distanceKm != null
                ? '${pharmacy.distanceKm!.toStringAsFixed(1)} '
                    '${LocaleKeys.pharmacy_distance.tr()}'
                : '',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (pharmacy.phone != null)
                SizedBox(
                  width: 100,
                  child: CallButton(
                    phoneNumber:
                        pharmacy.phone ?? LocaleKeys.null_pharmacy_phone.tr(),
                  ),
                ),
              const SizedBox(width: 5),
              Expanded(
                child: NavigateButton(
                  latLng: LatLng(pharmacy.latitude!, pharmacy.longitude!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
