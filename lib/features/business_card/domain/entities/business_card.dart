class BusinessCard {
  final String? id;
  final String? profileImagePath;
  final String fullName;
  final String jobTitle;
  final String companyName;
  final String mobileNumber;
  final String whatsappNumber;
  final String email;
  final String website;
  final String linkedin;
  final String facebook;
  final String instagram;
  final String telegram;
  final String address;
  final String aboutMe;

  const BusinessCard({
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
  });

  BusinessCard copyWith({
    String? id,
    String? profileImagePath,
    String? fullName,
    String? jobTitle,
    String? companyName,
    String? mobileNumber,
    String? whatsappNumber,
    String? email,
    String? website,
    String? linkedin,
    String? facebook,
    String? instagram,
    String? telegram,
    String? address,
    String? aboutMe,
    bool clearImage = false,
  }) {
    return BusinessCard(
      id: id ?? this.id,
      profileImagePath: clearImage ? null : (profileImagePath ?? this.profileImagePath),
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      telegram: telegram ?? this.telegram,
      address: address ?? this.address,
      aboutMe: aboutMe ?? this.aboutMe,
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id ?? '',
      'profileImagePath': profileImagePath ?? '',
      'fullName': fullName,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'mobileNumber': mobileNumber,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'website': website,
      'linkedin': linkedin,
      'facebook': facebook,
      'instagram': instagram,
      'telegram': telegram,
      'address': address,
      'aboutMe': aboutMe,
    };
  }

  factory BusinessCard.fromMap(Map<String, String> map) {
    return BusinessCard(
      id: map['id'],
      profileImagePath: map['profileImagePath']?.isEmpty == true ? null : map['profileImagePath'],
      fullName: map['fullName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      companyName: map['companyName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      whatsappNumber: map['whatsappNumber'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      linkedin: map['linkedin'] ?? '',
      facebook: map['facebook'] ?? '',
      instagram: map['instagram'] ?? '',
      telegram: map['telegram'] ?? '',
      address: map['address'] ?? '',
      aboutMe: map['aboutMe'] ?? '',
    );
  }
}
