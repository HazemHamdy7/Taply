import 'package:hive/hive.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/scanned_cards/data/models/scanned_card_model.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/domain/repositories/scanned_card_repository.dart';

class ScannedCardRepositoryImpl implements ScannedCardRepository {
  Box<ScannedCardModel> get _box => Hive.box<ScannedCardModel>(AppConstants.hiveScannedBoxName);

  @override
  Future<List<ScannedCard>> getAll() async {
    final models = _box.values.toList();
    models.sort((a, b) => b.scanDate.compareTo(a.scanDate));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> save(ScannedCard card) async {
    final model = ScannedCardModel.fromEntity(card);
    await _box.put(card.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final model = _box.get(id);
    if (model != null) {
      final updated = ScannedCardModel(
        id: model.id,
        fullName: model.fullName,
        jobTitle: model.jobTitle,
        companyName: model.companyName,
        tagline: model.tagline,
        mobileNumber: model.mobileNumber,
        whatsappNumber: model.whatsappNumber,
        email: model.email,
        website: model.website,
        linkedin: model.linkedin,
        facebook: model.facebook,
        instagram: model.instagram,
        telegram: model.telegram,
        youtube: model.youtube,
        x: model.x,
        address: model.address,
        aboutMe: model.aboutMe,
        templateId: model.templateId,
        profileImagePath: model.profileImagePath,
        scanDate: model.scanDate,
        isFavorite: !model.isFavorite,
      );
      await _box.put(id, updated);
    }
  }

  @override
  Future<List<ScannedCard>> search(String query) async {
    final all = await getAll();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((c) =>
      c.fullName.toLowerCase().contains(q) ||
      c.companyName.toLowerCase().contains(q) ||
      c.jobTitle.toLowerCase().contains(q) ||
      c.email.toLowerCase().contains(q) ||
      c.mobileNumber.contains(q),
    ).toList();
  }

  @override
  Future<bool> existsByData(ScannedCard card) async {
    final all = _box.values.toList();
    return all.any((c) =>
      c.fullName == card.fullName &&
      c.mobileNumber == card.mobileNumber &&
      c.email == card.email);
  }
}
