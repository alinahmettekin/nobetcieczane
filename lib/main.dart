import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/init/lang/translations/language_manager.dart';
import 'package:nobetcieczane/core/init/theme/cubit/theme_cubit.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:nobetcieczane/features/home/presentation/view/home/home_view.dart';
import 'package:nobetcieczane/init_dependencies.dart';

void main() async {
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator.get<HomeBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator.get<ThemeCubit>(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: LanguageManager.localePath,
        startLocale: LanguageManager.instance.trLocale,
        child: const NobetciEczane(),
      ),
    ),
  );
}

/// NobetciEczane is a StatelessWidget that contains the main app.
class NobetciEczane extends StatelessWidget {
  /// NobetciEczane constructor
  const NobetciEczane({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeData =
            state.theme == AppTheme.light ? state.lightTheme : state.darkTheme;
        return MaterialApp(
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: themeData,

          /// easy localization not working on firt build
          // ignore: prefer_const_constructors
          home: HomeView(),
        );
      },
    );
  }
}
