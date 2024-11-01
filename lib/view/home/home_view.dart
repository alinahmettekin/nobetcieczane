import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/components/custom_city_button.dart';
import 'package:nobetcieczane/core/components/custom_city_label.dart';
import 'package:nobetcieczane/core/components/custom_drawer.dart';
import 'package:nobetcieczane/core/components/custom_dropdown_menu.dart';
import 'package:nobetcieczane/core/helper/google_ads_helper.dart';
import 'package:nobetcieczane/core/model/cities_model.dart';
import 'package:nobetcieczane/core/theme/theme_provider.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
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
  final Connectivity _connectivity = Connectivity();
  late final listeningProvider = Provider.of<HomeViewModel>(context);
  late final readingProvider = Provider.of<HomeViewModel>(context, listen: false);
  bool isLoading = false;
  bool isHomePageLoading = true;

  @override
  void initState() {
    super.initState();
    GoogleAds.instance.loadBannerAd();
    GoogleAds.instance.loadInterstitialAd();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCityAndDistrict();
    await _loadSavedCities();
    setState(() {
      isHomePageLoading = false;
    });
  }

  _loadSavedCities() async {
    await readingProvider.getSavedCity();
  }

  _loadCityAndDistrict() async {
    await readingProvider.getCities();
  }

  void _showDropdownMenu(int value) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomDropdownMenu(
          value: value,
        );
      },
    );
  }

  void _showNetworkError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.red,
            ),
            Text("İnternet Bağlantısı Yok")
          ],
        ),
      ),
    );
  }

  void _navigateMapView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MapView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (isLoading) return;
          isLoading = true;
          List<ConnectivityResult> conntectivityResult = await _connectivity.checkConnectivity();
          if (conntectivityResult.contains(ConnectivityResult.mobile) ||
              conntectivityResult.contains(ConnectivityResult.wifi)) {
            if (readingProvider.searchCount == 1) {
              GoogleAds.instance.interstitialAd!.show();
              GoogleAds.instance.loadInterstitialAd();
            }
            readingProvider.setSearchCount();
            _navigateMapView();
            isLoading = false;
          } else {
            _showNetworkError();
            isLoading = false;
          }
        },
        child: const Icon(
          Icons.location_on,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          LocaleKeys.app_name.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: !isHomePageLoading
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
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
                        text: listeningProvider.selectedCity?.cities ?? LocaleKeys.choose_city.tr(),
                        onPressed: () async {
                          List<ConnectivityResult> conntectivityResult = await _connectivity.checkConnectivity();
                          if (conntectivityResult.contains(ConnectivityResult.mobile) ||
                              conntectivityResult.contains(ConnectivityResult.wifi)) {
                            if (readingProvider.cities.isEmpty) {
                              _loadCityAndDistrict();
                            }
                            _showDropdownMenu(0);
                          } else {
                            _showNetworkError();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomCityButton(
                        text: listeningProvider.selectedDistrict?.cities ?? LocaleKeys.choose_district.tr(),
                        onPressed: () => _showDropdownMenu(1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: listeningProvider.fillFieldValue,
                          child: Text(
                            LocaleKeys.fill_value_notifier.tr(),
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      CustomCityButton(
                        backgroundColor: Colors.red,
                        foregroundColor: Theme.of(context).colorScheme.secondary,
                        centerTitle: true,
                        text: LocaleKeys.search_button.tr(),
                        onPressed: () async {
                          List<ConnectivityResult> conntectivityResult = await _connectivity.checkConnectivity();
                          if (conntectivityResult.contains(ConnectivityResult.mobile) ||
                              conntectivityResult.contains(ConnectivityResult.wifi)) {
                            if (isLoading) return;

                            if (readingProvider.selectedCity?.slug != null &&
                                readingProvider.selectedDistrict?.slug != null) {
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
                          } else {
                            _showNetworkError();
                          }
                        },
                      ),
                      if (readingProvider.getSaved.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            child: Text(
                              LocaleKeys.quick_search.tr(),
                              textAlign: TextAlign.center,
                            ),
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
              )
            : const Center(
                child: CircularProgressIndicator(),
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
