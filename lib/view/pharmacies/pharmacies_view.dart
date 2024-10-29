import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/components/custom_pharmacy_tile.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

class PharmaciesView extends StatefulWidget {
  final List<Pharmacy> pharmacies;
  final String city;
  final String district;

  const PharmaciesView({
    super.key,
    required this.pharmacies,
    required this.city,
    required this.district,
  });

  @override
  State<PharmaciesView> createState() => _PharmaciesViewState();
}

class _PharmaciesViewState extends State<PharmaciesView> {
  late final readingProvider = Provider.of<HomeViewModel>(context, listen: false);
  String saveOption = "";

  @override
  void initState() {
    saveOption = readingProvider.isExist(widget.city, widget.district) ? 'Sil' : 'Kaydet';
    super.initState();
  }

  void showSaveSnackBar(bool response) {
    String? message;

    if (response) {
      message = "İlçe Kaydedildi";
    } else {
      message = "İlçe Silindi";
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Kapat',
        onPressed: () {
          // Snackbar'ı kapatma işlevi
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "${widget.city} - ${widget.district} ",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (readingProvider.isExist(widget.city, widget.district)) {
                String key = (widget.city.toString() + widget.district.toString()).toLowerCase();
                readingProvider.deleteSavedCity(key);
                setState(() {
                  saveOption = 'Kaydet';
                });
                showSaveSnackBar(false);
              } else {
                await readingProvider.setSavedCities(widget.city, widget.district);
                setState(() {
                  saveOption = 'Sil';
                });
                showSaveSnackBar(true);
              }
            },
            child: Text(
              saveOption,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.pharmacies.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text('Bu ilçede nöbetçi eczane bulunmamaktadır'),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.pharmacies.length,
                        itemBuilder: (context, index) {
                          final pharmacy = widget.pharmacies[index];
                          return CustomPharmacyTile(pharmacy: pharmacy);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
