import 'package:eczanemnerede/core/components/custom_city_button.dart';
import 'package:eczanemnerede/core/components/custom_drawer.dart';
import 'package:eczanemnerede/core/model/cities_model.dart';
import 'package:eczanemnerede/view/home/home_view_model.dart';
import 'package:eczanemnerede/view/map/map_view.dart.dart';
import 'package:eczanemnerede/view/pharmacies/pharmacies_view.dart';
import 'package:flutter/material.dart';
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
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          height: 300, // Yüksekliği belirleyin
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final city = list[index];
              return ListTile(
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
          'E C Z A N E M   N E R E D E',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
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
                height: 25,
              ),
              CustomCityButton(
                text: 'Nöbetçi Eczane Ara',
                onPressed: () async {
                  if (readingProvider.selectedCity?.slug != null && readingProvider.selectedDistrict?.slug != null) {
                    await readingProvider.getPharmacies(readingProvider.selectedCity!.slug.toString(),
                        readingProvider.selectedDistrict!.slug.toString());
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PharmaciesView(
                            pharmacies: readingProvider.pharmacies,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
