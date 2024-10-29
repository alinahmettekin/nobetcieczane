import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/theme/theme_provider.dart';
import 'package:nobetcieczane/view/home/home_view.dart';
import 'package:nobetcieczane/view/home/home_view_model.dart';
import 'package:nobetcieczane/view/map/map_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MobileAds.instance.initialize();
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();
  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => themeProvider),
            ChangeNotifierProvider(create: (context) => HomeViewModel()),
            ChangeNotifierProvider(create: (context) => MapViewModel()),
          ],
          child: const NobetciEczane(),
        ),
      );
    },
  );
}

class NobetciEczane extends StatelessWidget {
  const NobetciEczane({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomeView(),
    );
  }
}
