import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/init/theme/cubit/theme_cubit.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:nobetcieczane/init_dependencies.dart';

class ApplicationProvider {
  ApplicationProvider._init();
  static ApplicationProvider? _instance;
  static ApplicationProvider get instance {
    _instance ??= ApplicationProvider._init();
    return _instance!;
  }

  List<BlocProvider> providers(BuildContext context) {
    return [
      BlocProvider(
        create: (context) => serviceLocator.get<HomeBloc>(),
      ),
      BlocProvider(
        create: (context) => ThemeCubit(
          cacheService: serviceLocator.get(),
        ),
      ),
    ];
  }
}
