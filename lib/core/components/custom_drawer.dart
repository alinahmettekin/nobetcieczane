import 'package:flutter/material.dart';
import 'package:nobetcieczane/view/map/map_view.dart.dart';
import 'package:nobetcieczane/view/settings.dart/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.red,
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const SizedBox(
              height: 25,
            ),
            ListTile(
              onTap: () => Navigator.of(context).pop(),
              leading: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Geri',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.near_me, color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'NÖBETÇİ ECZANELER',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapView(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'AYARLAR',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
