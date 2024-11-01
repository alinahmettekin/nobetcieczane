import 'package:flutter/material.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
import 'package:nobetcieczane/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

class CustomDropdownMenu extends StatefulWidget {
  final int value;
  const CustomDropdownMenu({super.key, required this.value});

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary,
          ),
          height: 300,
          child: Consumer<HomeViewModel>(
            builder: (context, provider, child) {
              // widget.value 0 ise cities, 1 ise districts listesini kontrol et
              final items = widget.value == 0 ? provider.cities : provider.districts;
              if ((widget.value == 1 && provider.selectedCity == null)) {
                return const Center(
                  child: Text(LocaleKeys.dropdown_null_value_notifier),
                );
              } else if (((widget.value == 1 && provider.districts.isEmpty)) ||
                  (widget.value == 0 && provider.cities.isEmpty)) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final city = items[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(city.cities.toString()),
                        onTap: () async {
                          Navigator.of(context).pop();
                          if (widget.value == 0) {
                            provider.setSelectedCity(city);
                            provider.getDistrict();
                          } else {
                            provider.setSelectedDistrict(city);
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
              );
            },
          ),
        );
      },
    );
  }
}
