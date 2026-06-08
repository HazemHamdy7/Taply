import 'package:business_card/features/business_card/domain/entities/business_card.dart';

class ScannedCard {
  final String id;
  final String cardId;
  final String fullName;
  final String jobTitle;
  final String companyName;
  final String tagline;
  final String mobileNumber;
  final String mobileNumber2;
  final String whatsappNumber;
  final String email;
  final String website;
  final String linkedin;
  final String facebook;
  final String instagram;
  final String telegram;
  final String youtube;
  final String x;
  final String address;
  final String aboutMe;
  final String templateId;
  final String? profileImagePath;
  final DateTime scanDate;
  final bool isFavorite;
  final List<String> categoryIds;

  const ScannedCard({
    required this.id,
    this.cardId = '',
    this.fullName = '',
    this.jobTitle = '',
    this.companyName = '',
    this.tagline = '',
    this.mobileNumber = '',
    this.mobileNumber2 = '',
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
    this.categoryIds = const [],
  });

  BusinessCard toBusinessCard() {
    return BusinessCard(
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
    );
  }

  ScannedCard copyWith({
    String? id,
    String? cardId,
    String? fullName,
    String? jobTitle,
    String? companyName,
    String? tagline,
    String? mobileNumber,
    String? mobileNumber2,
    String? whatsappNumber,
    String? email,
    String? website,
    String? linkedin,
    String? facebook,
    String? instagram,
    String? telegram,
    String? youtube,
    String? x,
    String? address,
    String? aboutMe,
    String? templateId,
    String? profileImagePath,
    DateTime? scanDate,
    bool? isFavorite,
    List<String>? categoryIds,
    bool clearImage = false,
  }) {
    return ScannedCard(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      tagline: tagline ?? this.tagline,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      mobileNumber2: mobileNumber2 ?? this.mobileNumber2,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      telegram: telegram ?? this.telegram,
      youtube: youtube ?? this.youtube,
      x: x ?? this.x,
      address: address ?? this.address,
      aboutMe: aboutMe ?? this.aboutMe,
      templateId: templateId ?? this.templateId,
      profileImagePath: clearImage ? null : (profileImagePath ?? this.profileImagePath),
      scanDate: scanDate ?? this.scanDate,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }
}
