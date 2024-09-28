import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/components/custom_maps_button.dart';
import 'package:nobetcieczane/core/components/custom_phone_call_button.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';

class CustomPharmacyTile extends StatelessWidget {
  final Pharmacy pharmacy;
  const CustomPharmacyTile({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_pharmacy_outlined,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  pharmacy.pharmacyName ?? 'İsim Bulunamadı',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(pharmacy.address ?? 'Adres bulunamadı'),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 10,
              ),
              Text(
                pharmacy.phone ?? 'Telefon Numarası bulunamadı',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            pharmacy.directions ?? '',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 100, child: CustomPhoneCallButton(phone: pharmacy.phone ?? 'Telefon Bulunamadı')),
              const SizedBox(width: 5),
              Expanded(
                child: CustomMapsButton(
                  latLng: LatLng(pharmacy.latitude!, pharmacy.longitude!),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
