// ignore_for_file: annotate_overrides, overridden_fields

import 'package:hive/hive.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';

part 'scanned_card_model.g.dart';

@HiveType(typeId: 1)
class ScannedCardModel extends ScannedCard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String jobTitle;

  @HiveField(3)
  final String companyName;

  @HiveField(4)
  final String tagline;

  @HiveField(5)
  final String mobileNumber;

  @HiveField(6)
  final String whatsappNumber;

  @HiveField(7)
  final String email;

  @HiveField(8)
  final String website;

  @HiveField(9)
  final String linkedin;

  @HiveField(10)
  final String facebook;

  @HiveField(11)
  final String instagram;

  @HiveField(12)
  final String telegram;

  @HiveField(13)
  final String youtube;

  @HiveField(14)
  final String x;

  @HiveField(15)
  final String address;

  @HiveField(16)
  final String aboutMe;

  @HiveField(17)
  final String templateId;

  @HiveField(18)
  final String? profileImagePath;

  @HiveField(19)
  final DateTime scanDate;

  @HiveField(20)
  final bool isFavorite;

  @HiveField(21)
  final String mobileNumber2;

  const ScannedCardModel({
    required this.id,
    this.fullName = '',
    this.jobTitle = '',
    this.companyName = '',
    this.tagline = '',
    this.mobileNumber = '',
    this.whatsappNumber = '',
    this.email = '',
    this.website = '',
    this.linkedin = '',
    this.facebook = '',
    this.instagram = '',
    this.telegram = '',
    this.youtube = '',
    this.x = '',
    this.address = '',
    this.aboutMe = '',
    this.templateId = 'default',
    this.profileImagePath,
    required this.scanDate,
    this.isFavorite = false,
    this.mobileNumber2 = '',
  }) : super(
          id: id,
          fullName: fullName,
          jobTitle: jobTitle,
          companyName: companyName,
          tagline: tagline,
          mobileNumber: mobileNumber,
          mobileNumber2: mobileNumber2,
          whatsappNumber: whatsappNumber,
          email: email,
          website: website,
          linkedin: linkedin,
          facebook: facebook,
          instagram: instagram,
          telegram: telegram,
          youtube: youtube,
          x: x,
          address: address,
          aboutMe: aboutMe,
          templateId: templateId,
          profileImagePath: profileImagePath,
          scanDate: scanDate,
          isFavorite: isFavorite,
        );

  factory ScannedCardModel.fromEntity(ScannedCard entity) {
    return ScannedCardModel(
      id: entity.id,
      fullName: entity.fullName,
      jobTitle: entity.jobTitle,
      companyName: entity.companyName,
      tagline: entity.tagline,
      mobileNumber: entity.mobileNumber,
      mobileNumber2: entity.mobileNumber2,
      whatsappNumber: entity.whatsappNumber,
      email: entity.email,
      website: entity.website,
      linkedin: entity.linkedin,
      facebook: entity.facebook,
      instagram: entity.instagram,
      telegram: entity.telegram,
      youtube: entity.youtube,
      x: entity.x,
      address: entity.address,
      aboutMe: entity.aboutMe,
      templateId: entity.templateId,
      profileImagePath: entity.profileImagePath,
      scanDate: entity.scanDate,
      isFavorite: entity.isFavorite,
    );
  }

  ScannedCard toEntity() {
    return ScannedCard(
      id: id,
      fullName: fullName,
      jobTitle: jobTitle,
      companyName: companyName,
      tagline: tagline,
      mobileNumber: mobileNumber,
      mobileNumber2: mobileNumber2,
      whatsappNumber: whatsappNumber,
      email: email,
      website: website,
      linkedin: linkedin,
      facebook: facebook,
      instagram: instagram,
      telegram: telegram,
      youtube: youtube,
      x: x,
      address: address,
      aboutMe: aboutMe,
      templateId: templateId,
      profileImagePath: profileImagePath,
      scanDate: scanDate,
      isFavorite: isFavorite,
    );
  }
}
