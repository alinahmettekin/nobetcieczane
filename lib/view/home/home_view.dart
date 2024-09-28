import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/components/custom_city_button.dart';
import 'package:nobetcieczane/core/components/custom_drawer.dart';
import 'package:nobetcieczane/core/helper/google_ads_helper.dart';
import 'package:nobetcieczane/core/model/cities_model.dart';
import 'package:nobetcieczane/core/theme/theme_provider.dart';
import 'package:nobetcieczane/view/home/home_view_model.dart';
import 'package:nobetcieczane/view/map/map_view.dart.dart';
import 'package:nobetcieczane/view/pharmacies/pharmacies_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final listeningProvider = Provider.of<HomeViewModel>(context);
  late final readingProvider = Provider.of<HomeViewModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    GoogleAds.instance.loadBannerAd();
    _loadCityAndDistrict();
  }

  _loadCityAndDistrict() async {
    await readingProvider.getCities();
  }

  void _showDropdownMenu(List<Cities> list, int value) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary,
          ),
          height: 300,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final city = list[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(city.cities.toString()),
                    onTap: () async {
                      Navigator.of(context).pop();
                      if (value == 0) {
                        readingProvider.setSelectedCity(city);
                        await readingProvider.getDistrict();
                      } else {
                        readingProvider.setSelectedDistrict(city);
                      }
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                    height: 10,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MapView(),
            ),
          );
        },
        child: const Icon(
          Icons.location_on,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'N Ö B E T Ç İ  E C Z A N E',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              icon: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode)),
        ],
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (GoogleAds.instance.bannerAd != null)
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: AdWidget(ad: GoogleAds.instance.bannerAd!),
                    ),
                  ),
                ),
              const SizedBox(
                height: 45,
              ),
              CustomCityButton(
                text: listeningProvider.selectedCity?.cities ?? 'Şehir seçin...',
                onPressed: () => _showDropdownMenu(readingProvider.cities, 0),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomCityButton(
                text: listeningProvider.selectedDistrict?.cities ?? 'İlçe seçin...',
                onPressed: () => _showDropdownMenu(readingProvider.districts, 1),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: listeningProvider.fillFieldValue,
                  child: const Text(
                    'Lütfen şehir ve ilçe bilgilerini doldurun',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomCityButton(
                backgroundColor: Colors.red,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                text: 'Nöbetçi Eczane Ara',
                onPressed: () async {
                  if (readingProvider.selectedCity?.slug != null && readingProvider.selectedDistrict?.slug != null) {
                    await readingProvider.getPharmacies(
                        readingProvider.selectedCity!.slug!, readingProvider.selectedDistrict!.slug!);
                    _navigatePharmaciesView();
                  } else {
                    readingProvider.setFillFieldValue(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigatePharmaciesView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PharmaciesView(
          pharmacies: readingProvider.pharmacies,
        ),
      ),
    );
  }
}
