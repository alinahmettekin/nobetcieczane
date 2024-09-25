import 'package:eczanemnerede/view/settings.dart/settings_view.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: ListView(
        children: [
          const Icon(
            Icons.local_pharmacy_outlined,
            color: Colors.red,
            size: 72,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('AYARLAR'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SettingsView(),
            )),
          ),
          const ListTile(
            leading: Icon(Icons.medical_services_rounded),
            title: Text('TÜM ECZANELER'),
          )
        ],
      ),
    ));
  }
}
