class CountryCode {
  final String name;
  final String dialCode;
  final String flag;

  const CountryCode({
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  static const List<CountryCode> defaultList = [
    CountryCode(name: 'India', dialCode: '+91', flag: '🇮🇳'),
    CountryCode(name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪'),
    CountryCode(name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦'),
    CountryCode(name: 'Qatar', dialCode: '+974', flag: '🇶🇦'),
    CountryCode(name: 'Oman', dialCode: '+968', flag: '🇴🇲'),
    CountryCode(name: 'Kuwait', dialCode: '+965', flag: '🇰🇼'),
    CountryCode(name: 'Bahrain', dialCode: '+973', flag: '🇧🇭'),
    CountryCode(name: 'United States', dialCode: '+1', flag: '🇺🇸'),
    CountryCode(name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧'),
  ];
}
