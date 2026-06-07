import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/business_card/data/models/business_card_model.dart';
import 'package:business_card/features/business_card/data/repositories/business_card_repository_impl.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';
import 'package:business_card/features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initHive();
  await _initSharedPreferences();
  _initRepositories();
  _initCubits();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BusinessCardModelAdapter());
  await Hive.openBox<BusinessCardModel>(AppConstants.hiveBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);
}

Future<void> _initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
}

void _initRepositories() {
  sl.registerLazySingleton<BusinessCardRepository>(
    () => BusinessCardRepositoryImpl(),
  );
}

void _initCubits() {
  sl.registerLazySingleton(() => BusinessCardCubit(sl()));
  sl.registerLazySingleton(() => NfcCubit());
  sl.registerLazySingleton(() => SettingsCubit(sl()));
}
