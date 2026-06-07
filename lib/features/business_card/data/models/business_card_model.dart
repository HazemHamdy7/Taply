import 'package:hive/hive.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';

part 'business_card_model.g.dart';

// ignore_for_file: annotate_overrides, overridden_fields

@HiveType(typeId: 0)
class BusinessCardModel extends BusinessCard {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? profileImagePath;

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String jobTitle;

  @HiveField(4)
  final String companyName;

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
  final String address;

  @HiveField(14)
  final String aboutMe;

  const BusinessCardModel({
    this.id,
    this.profileImagePath,
    this.fullName = '',
    this.jobTitle = '',
    this.companyName = '',
    this.mobileNumber = '',
    this.whatsappNumber = '',
    this.email = '',
    this.website = '',
    this.linkedin = '',
    this.facebook = '',
    this.instagram = '',
    this.telegram = '',
    this.address = '',
    this.aboutMe = '',
  }) : super(
          id: id,
          profileImagePath: profileImagePath,
          fullName: fullName,
          jobTitle: jobTitle,
          companyName: companyName,
          mobileNumber: mobileNumber,
          whatsappNumber: whatsappNumber,
          email: email,
          website: website,
          linkedin: linkedin,
          facebook: facebook,
          instagram: instagram,
          telegram: telegram,
          address: address,
          aboutMe: aboutMe,
        );

  factory BusinessCardModel.fromEntity(BusinessCard entity) {
    return BusinessCardModel(
      id: entity.id,
      profileImagePath: entity.profileImagePath,
      fullName: entity.fullName,
      jobTitle: entity.jobTitle,
      companyName: entity.companyName,
      mobileNumber: entity.mobileNumber,
      whatsappNumber: entity.whatsappNumber,
      email: entity.email,
      website: entity.website,
      linkedin: entity.linkedin,
      facebook: entity.facebook,
      instagram: entity.instagram,
      telegram: entity.telegram,
      address: entity.address,
      aboutMe: entity.aboutMe,
    );
  }

  BusinessCard toEntity() {
    return BusinessCard(
      id: id,
      profileImagePath: profileImagePath,
      fullName: fullName,
      jobTitle: jobTitle,
      companyName: companyName,
      mobileNumber: mobileNumber,
      whatsappNumber: whatsappNumber,
      email: email,
      website: website,
      linkedin: linkedin,
      facebook: facebook,
      instagram: instagram,
      telegram: telegram,
      address: address,
      aboutMe: aboutMe,
    );
  }
}
