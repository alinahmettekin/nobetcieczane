import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nobetcieczane/core/init/network/connection_checker.dart';
import 'package:nobetcieczane/core/init/network/http_service.dart';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';
import 'package:nobetcieczane/core/init/theme/cubit/theme_cubit.dart';
import 'package:nobetcieczane/features/home/data/datasources/home_remote_data_source.dart';
import 'package:nobetcieczane/features/home/data/repositories/home_repository_impl.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_cities.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_districts.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_near_pharmacies.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_pharmacies.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'init_dependencies.main.dart';
