/// Structured data for a business card.
class BusinessCardData {
  final String? name;
  final String? title;
  final String? company;
  final String? email;
  final String? phone;
  final String? website;
  final String? address;
  final String? avatarUrl;
  final Map<String, String> custom;

  const BusinessCardData({
    this.name,
    this.title,
    this.company,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.avatarUrl,
    this.custom = const {},
  });

  String? operator [](String key) {
    return switch (key) {
      'name' => name,
      'title' => title,
      'company' => company,
      'email' => email,
      'phone' => phone,
      'website' => website,
      'address' => address,
      'avatarUrl' => avatarUrl,
      _ => custom[key],
    };
  }

  static const empty = BusinessCardData();

  Map<String, dynamic> toMap() => {
        if (name != null) 'name': name,
        if (title != null) 'title': title,
        if (company != null) 'company': company,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
        if (address != null) 'address': address,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        ...custom,
      };

  BusinessCardData copyWith({
    String? name,
    String? title,
    String? company,
    String? email,
    String? phone,
    String? website,
    String? address,
    String? avatarUrl,
    Map<String, String>? custom,
  }) {
    return BusinessCardData(
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      custom: custom ?? this.custom,
    );
  }
}
