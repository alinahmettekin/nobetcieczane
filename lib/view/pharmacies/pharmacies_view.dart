import 'package:eczanemnerede/core/model/pharmacy_model.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: ListView.builder(
            itemCount: widget.pharmacies.length,
            itemBuilder: (context, index) {
              final pharmacy = widget.pharmacies[index];
              return Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
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
                        Text(
                          pharmacy.pharmacyName ?? 'İsim Bulunamadı',
                          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Adres: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          pharmacy.address ?? 'Adres bulunamadı',
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
