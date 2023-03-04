class Drug {
  String name;
  String activeSubstance;
  String firmaAdi;
  int barkod;

  Drug({
    required this.name,
    required this.activeSubstance,
    required this.firmaAdi,
    required this.barkod,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
        name: json['ilac_adi'] as String,
        activeSubstance: json['atc_adi'] as String,
        firmaAdi: json['firma_adi'] as String,
        barkod: json['barkod'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'ilac_adi': name,
      'atc_adi': activeSubstance,
      'firma_adi': firmaAdi,
      'barkod': barkod,
    };
  }

  @override
  String toString() {
    return 'Drug(name: $name, activeSubstance: $activeSubstance, firmaAdi: $firmaAdi, barkod: $barkod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Drug &&
        other.name == name &&
        other.activeSubstance == activeSubstance &&
        other.firmaAdi == firmaAdi &&
        other.barkod == barkod;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        activeSubstance.hashCode ^
        firmaAdi.hashCode ^
        barkod.hashCode;
  }

  Drug copyWith({
    String? name,
    String? activeSubstance,
    String? firmaAdi,
    int? barkod,
  }) {
    return Drug(
      name: name ?? this.name,
      activeSubstance: activeSubstance ?? this.activeSubstance,
      firmaAdi: firmaAdi ?? this.firmaAdi,
      barkod: barkod ?? this.barkod,
    );
  }
}
