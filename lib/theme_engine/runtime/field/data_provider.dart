import '../runtime_exception.dart';

class BusinessCardData {
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? jobTitle;
  final String? company;
  final String? email;
  final String? phone;
  final String? website;
  final String? address;
  final String? bio;
  final String? profileImage;
  final String? coverImage;
  final String? logo;
  final String? qr;
  final String? nfc;
  final Map<String, String> social;
  final Map<String, dynamic> custom;
  final Map<String, dynamic> extra;

  const BusinessCardData({
    this.fullName,
    this.firstName,
    this.lastName,
    this.jobTitle,
    this.company,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.bio,
    this.profileImage,
    this.coverImage,
    this.logo,
    this.qr,
    this.nfc,
    this.social = const {},
    this.custom = const {},
    this.extra = const {},
  });

  BusinessCardData merge(BusinessCardData other) {
    return BusinessCardData(
      fullName: other.fullName ?? fullName,
      firstName: other.firstName ?? firstName,
      lastName: other.lastName ?? lastName,
      jobTitle: other.jobTitle ?? jobTitle,
      company: other.company ?? company,
      email: other.email ?? email,
      phone: other.phone ?? phone,
      website: other.website ?? website,
      address: other.address ?? address,
      bio: other.bio ?? bio,
      profileImage: other.profileImage ?? profileImage,
      coverImage: other.coverImage ?? coverImage,
      logo: other.logo ?? logo,
      qr: other.qr ?? qr,
      nfc: other.nfc ?? nfc,
      social: {...social, ...other.social},
      custom: {...custom, ...other.custom},
      extra: {...extra, ...other.extra},
    );
  }

  dynamic resolve(String path) {
    switch (path) {
      case 'fullName':   return fullName;
      case 'firstName':  return firstName;
      case 'lastName':   return lastName;
      case 'jobTitle':   return jobTitle;
      case 'company':    return company;
      case 'email':      return email;
      case 'phone':      return phone;
      case 'website':    return website;
      case 'address':    return address;
      case 'bio':        return bio;
      case 'profileImage': return profileImage;
      case 'coverImage':   return coverImage;
      case 'logo':       return logo;
      case 'qr':         return qr;
      case 'nfc':        return nfc;
      default:
        if (path.startsWith('social.')) {
          final key = path.substring(7);
          return social[key];
        }
        if (path.startsWith('custom.')) {
          final key = path.substring(7);
          return custom[key];
        }
        return extra[path];
    }
  }
}

class DataProvider {
  BusinessCardData? _data;

  bool get isInitialized => _data != null;

  DataProvider({BusinessCardData? data}) : _data = data;

  BusinessCardData get data {
    if (_data == null) throw const RuntimeException('DataProvider not initialized', code: 'DATA_NOT_SET');
    return _data!;
  }

  void setData(BusinessCardData data) {
    _data = data;
  }

  void updateField(String key, dynamic value) {
    final current = _data ?? const BusinessCardData();
    final updated = current.merge(BusinessCardData(extra: {key: value}));
    _data = updated;
  }

  dynamic resolve(String path) {
    return data.resolve(path);
  }

  Map<String, dynamic> allFields() {
    final d = data;
    return {
      if (d.fullName != null) 'fullName': d.fullName,
      if (d.firstName != null) 'firstName': d.firstName,
      if (d.lastName != null) 'lastName': d.lastName,
      if (d.jobTitle != null) 'jobTitle': d.jobTitle,
      if (d.company != null) 'company': d.company,
      if (d.email != null) 'email': d.email,
      if (d.phone != null) 'phone': d.phone,
      if (d.website != null) 'website': d.website,
      if (d.address != null) 'address': d.address,
      if (d.bio != null) 'bio': d.bio,
      if (d.profileImage != null) 'profileImage': d.profileImage,
      if (d.coverImage != null) 'coverImage': d.coverImage,
      if (d.logo != null) 'logo': d.logo,
      if (d.qr != null) 'qr': d.qr,
      if (d.nfc != null) 'nfc': d.nfc,
      ...d.social.map((k, v) => MapEntry('social.$k', v)),
      ...d.custom.map((k, v) => MapEntry('custom.$k', v)),
      ...d.extra,
    };
  }
}
