import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/components/custom_maps_button.dart';
import 'package:nobetcieczane/core/components/custom_pharmacy_tile.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';

class PharmaciesView extends StatefulWidget {
  final List<Pharmacy> pharmacies;
  const PharmaciesView({
    super.key,
    required this.pharmacies,
  });

  @override
  State<PharmaciesView> createState() => _PharmaciesViewState();
}

class _PharmaciesViewState extends State<PharmaciesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: widget.pharmacies.isEmpty
            ? const Center(
                child: Text('Bu ilçede nöbetçi eczane bulunmamaktadır'),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ListView.builder(
                  itemCount: widget.pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = widget.pharmacies[index];
                    return CustomPharmacyTile(pharmacy: pharmacy);
                  },
                ),
              ),
      ),
    );
  }
}
