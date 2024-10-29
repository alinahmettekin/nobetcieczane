import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/components/custom_city_button.dart';
import 'package:nobetcieczane/core/components/custom_city_label.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    GoogleAds.instance.loadBannerAd();
    GoogleAds.instance.loadInterstitialAd();
    _loadCityAndDistrict();
    _loadSavedCities();
  }

  _loadSavedCities() async {
    await readingProvider.getSavedCity();
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
                        readingProvider.getDistrict();
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
          'N Ö B E T Ç İ   E C Z A N E',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                if (GoogleAds.instance.bannerAd != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: AdWidget(ad: GoogleAds.instance.bannerAd!),
                        ),
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
                CustomCityButton(
                  backgroundColor: Colors.red,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  centerTitle: true,
                  text: 'Nöbetçi Eczane Ara',
                  onPressed: () async {
                    if (isLoading) return;

                    if (readingProvider.selectedCity?.slug != null && readingProvider.selectedDistrict?.slug != null) {
                      isLoading = true;
                      readingProvider.setFillFieldValue(false);

                      if (readingProvider.searchCount == 1) {
                        GoogleAds.instance.interstitialAd!.show();
                        GoogleAds.instance.loadInterstitialAd();
                      }
                      readingProvider.setSearchCount();
                      await readingProvider.getPharmacies(
                          readingProvider.selectedCity!.slug!, readingProvider.selectedDistrict!.slug!);
                      _navigatePharmaciesView(readingProvider.selectedCity!, readingProvider.selectedDistrict!);
                      isLoading = false;
                    } else {
                      readingProvider.setFillFieldValue(true);
                    }
                  },
                ),
                if (readingProvider.getSaved.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      child: Text("Daha hızlı arama yapabilmek için şehirleri kaydedebilirsiniz"),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (readingProvider.getSaved.isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: readingProvider.getSaved.length,
                    itemBuilder: (context, index) {
                      final entry = listeningProvider.getSaved.entries.elementAt(index);
                      return CustomCityLabel(
                          onTap: () async {
                            if (!isLoading) {
                              isLoading = true;
                              if (readingProvider.searchCount == 1) {
                                GoogleAds.instance.interstitialAd!.show();
                                GoogleAds.instance.loadInterstitialAd();
                              }
                              readingProvider.setSearchCount();

                              Cities city = Cities(cities: entry.value[0], slug: entry.value[2]);
                              Cities district = Cities(cities: entry.value[1], slug: entry.value[3]);

                              await readingProvider.getPharmacies(city.slug!, district.slug!);
                              _navigatePharmaciesViewOnSaved(city, district);
                              isLoading = false;
                            } else {
                              return;
                            }
                          },
                          onTrailingTap: () => readingProvider.deleteSavedCity(entry.key),
                          text: "${entry.value[0]} - "
                              "${entry.value[1]}");
                    },
                  ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navigatePharmaciesView(Cities city, Cities district) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PharmaciesView(
          pharmacies: readingProvider.pharmacies,
          city: readingProvider.selectedCity?.cities ?? '',
          district: readingProvider.selectedDistrict?.cities ?? '',
        ),
      ),
    );
  }

  _navigatePharmaciesViewOnSaved(Cities city, Cities district) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PharmaciesView(
          pharmacies: readingProvider.pharmacies,
          city: city.cities ?? '',
          district: district.cities ?? '',
        ),
      ),
    );
  }
}
