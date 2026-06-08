import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/analytics/data/models/analytics_event_model.dart';
import 'package:business_card/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:business_card/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:business_card/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:business_card/features/business_card/data/models/business_card_model.dart';
import 'package:business_card/features/networking_score/domain/services/networking_score_service.dart';
import 'package:business_card/features/networking_score/presentation/cubit/networking_score_cubit.dart';
import 'package:business_card/features/business_card/data/repositories/business_card_repository_impl.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/categories/data/models/category_model.dart';
import 'package:business_card/features/categories/data/repositories/category_repository_impl.dart';
import 'package:business_card/features/categories/domain/repositories/category_repository.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';
import 'package:business_card/features/scanned_cards/data/models/scanned_card_model.dart';
import 'package:business_card/features/scanned_cards/data/repositories/scanned_card_repository_impl.dart';
import 'package:business_card/features/scanned_cards/domain/repositories/scanned_card_repository.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';
import 'package:business_card/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:business_card/shared/template_engine/template_loader.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initHive();
  await _initSharedPreferences();
  await _initTemplates();
  await _initCategories();
  _initRepositories();
  _initCubits();
}

Future<void> _initTemplates() async {
  try {
    await TemplateLoader.loadAll();
  } catch (_) {}
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BusinessCardModelAdapter());
  Hive.registerAdapter(ScannedCardModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(AnalyticsEventModelAdapter());
  await Hive.openBox<BusinessCardModel>(AppConstants.hiveBoxName);
  await Hive.openBox<ScannedCardModel>(AppConstants.hiveScannedBoxName);
  await Hive.openBox<CategoryModel>(AppConstants.categoriesBoxName);
  await Hive.openBox<AnalyticsEventModel>(AppConstants.analyticsBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);
}

Future<void> _initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
}

Future<void> _initCategories() async {
  final repo = CategoryRepositoryImpl();
  await repo.ensureDefaults();
  sl.registerLazySingleton<CategoryRepository>(() => repo);
}

void _initRepositories() {
  sl.registerLazySingleton<BusinessCardRepository>(
    () => BusinessCardRepositoryImpl(),
  );
  sl.registerLazySingleton<ScannedCardRepository>(
    () => ScannedCardRepositoryImpl(),
  );
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(),
  );
}

void _initCubits() {
  sl.registerLazySingleton(() => BusinessCardCubit(sl()));
  sl.registerLazySingleton(() => NfcCubit());
  sl.registerLazySingleton(() => ScannedCardCubit(sl()));
  sl.registerLazySingleton(() => SettingsCubit(sl()));
  sl.registerLazySingleton(() => CategoryCubit(sl()));
  sl.registerLazySingleton(() => AnalyticsCubit(sl()));
  sl.registerLazySingleton(() => NetworkingScoreService());
  sl.registerLazySingleton(
    () => NetworkingScoreCubit(sl(), sl(), sl()),
  );
}
