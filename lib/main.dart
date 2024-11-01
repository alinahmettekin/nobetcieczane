import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/theme/theme_provider.dart';
import 'package:nobetcieczane/translations/codegen_loader.g.dart';
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
  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) {
      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
          path: 'assets/translations',
          assetLoader: const CodegenLoader(),
          fallbackLocale: const Locale('tr', 'TR'),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => themeProvider),
              ChangeNotifierProvider(create: (context) => HomeViewModel()),
              ChangeNotifierProvider(create: (context) => MapViewModel())
            ],
            child: const NobetciEczane(),
          ),
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
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomeView(),
    );
  }
}
