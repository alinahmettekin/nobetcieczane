import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/components/custom_pharmacy_tile.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
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
    saveOption =
        readingProvider.isExist(widget.city, widget.district) ? LocaleKeys.delete_text.tr() : LocaleKeys.save_text.tr();
    super.initState();
  }

  void showSaveSnackBar(bool response) {
    String? message;

    if (response) {
      message = LocaleKeys.district_saved.tr();
    } else {
      message = LocaleKeys.district_deleted.tr();
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: LocaleKeys.close_text.tr(),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: Text(
          "${widget.city.toUpperCase()} - ${widget.district.toUpperCase()} ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (readingProvider.isExist(widget.city, widget.district)) {
                String key = (widget.city.toString() + widget.district.toString()).toLowerCase();
                readingProvider.deleteSavedCity(key);
                setState(() {
                  saveOption = LocaleKeys.save_text.tr();
                });
                showSaveSnackBar(false);
              } else {
                await readingProvider.setSavedCities(widget.city, widget.district);
                setState(() {
                  saveOption = LocaleKeys.delete_text.tr();
                });
                showSaveSnackBar(true);
              }
            },
            child: Text(
              saveOption,
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.pharmacies.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(LocaleKeys.empty_duty_pharmacies.tr()),
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
