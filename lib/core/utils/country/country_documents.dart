import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryDocument {
  final int id;
  final String countryName;
  final String documentName;
  final String documentCode;
  final String countryCode;     // ISO-2 (BR, US, PT...)
  final String phoneDialCode;   // +55, +1, +351...

  CountryDocument({
    required this.id,
    required this.countryName,
    required this.documentName,
    required this.documentCode,
    required this.countryCode,
    required this.phoneDialCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryDocument &&
        other.countryName == countryName &&
        other.documentName == documentName &&
        other.documentCode == documentCode &&
        other.countryCode == countryCode &&
        other.phoneDialCode == phoneDialCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      countryName,
      documentName,
      documentCode,
      countryCode,
      phoneDialCode,
    );
  }

  Widget getFlagWidget(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: 'https://flagcdn.com/w40/${countryCode.toLowerCase()}.png',
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
        ),
        errorWidget: (context, url, error) =>  Icon(Icons.flag, size: 16.r),
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
      ),
    );
  }
}

class CountryDocuments {
  static List<CountryDocument> documents = [

    // 🇧🇷 Brasil
    CountryDocument(
      id: 24,
      countryName: 'Brasil',
      documentName: 'CPF',
      documentCode: 'CPF',
      countryCode: 'BR',
      phoneDialCode: '+55',
    ),

    // 🇺🇸 Estados Unidos
    CountryDocument(
      id: 184,
      countryName: 'Estados Unidos',
      documentName: 'Social Security Number',
      documentCode: 'SSN',
      countryCode: 'US',
      phoneDialCode: '+1',
    ),

    // 🇨🇦 Canadá
    CountryDocument(
      id: 31,
      countryName: 'Canadá',
      documentName: 'Social Insurance Number',
      documentCode: 'SIN',
      countryCode: 'CA',
      phoneDialCode: '+1',
    ),

    // 🇵🇹 Portugal
    CountryDocument(
      id: 139,
      countryName: 'Portugal',
      documentName: 'Cartão de Cidadão',
      documentCode: 'CC',
      countryCode: 'PT',
      phoneDialCode: '+351',
    ),

    // 🇦🇷 Argentina
    CountryDocument(
      id: 7,
      countryName: 'Argentina',
      documentName: 'DNI',
      documentCode: 'DNI',
      countryCode: 'AR',
      phoneDialCode: '+54',
    ),

    // 🇨🇱 Chile
    CountryDocument(
      id: 35,
      countryName: 'Chile',
      documentName: 'RUT',
      documentCode: 'RUT',
      countryCode: 'CL',
      phoneDialCode: '+56',
    ),

    // 🇲🇽 México
    CountryDocument(
      id: 113,
      countryName: 'México',
      documentName: 'CURP',
      documentCode: 'CURP',
      countryCode: 'MX',
      phoneDialCode: '+52',
    ),

    // 🇫🇷 França
    CountryDocument(
      id: 61,
      countryName: 'França',
      documentName: 'Carte Nationale d\'Identité',
      documentCode: 'CNI',
      countryCode: 'FR',
      phoneDialCode: '+33',
    ),

    // 🇩🇪 Alemanha
    CountryDocument(
      id: 65,
      countryName: 'Alemanha',
      documentName: 'Personalausweis',
      documentCode: 'PA',
      countryCode: 'DE',
      phoneDialCode: '+49',
    ),

    // 🇪🇸 Espanha
    CountryDocument(
      id: 162,
      countryName: 'Espanha',
      documentName: 'DNI',
      documentCode: 'DNI',
      countryCode: 'ES',
      phoneDialCode: '+34',
    ),

    // 🇮🇹 Itália
    CountryDocument(
      id: 83,
      countryName: 'Itália',
      documentName: 'Carta d\'Identità',
      documentCode: 'CI',
      countryCode: 'IT',
      phoneDialCode: '+39',
    ),

    // 🇬🇧 Reino Unido
    CountryDocument(
      id: 183,
      countryName: 'Reino Unido',
      documentName: 'National Insurance Number',
      documentCode: 'NIN',
      countryCode: 'GB',
      phoneDialCode: '+44',
    ),

    // 🇯🇵 Japão
    CountryDocument(
      id: 85,
      countryName: 'Japão',
      documentName: 'My Number',
      documentCode: 'MN',
      countryCode: 'JP',
      phoneDialCode: '+81',
    ),

    // 🇨🇳 China
    CountryDocument(
      id: 36,
      countryName: 'China',
      documentName: 'ID Card',
      documentCode: 'IDC',
      countryCode: 'CN',
      phoneDialCode: '+86',
    ),

    // 🇮🇳 Índia
    CountryDocument(
      id: 77,
      countryName: 'Índia',
      documentName: 'Aadhaar',
      documentCode: 'AAD',
      countryCode: 'IN',
      phoneDialCode: '+91',
    ),

    // 🇦🇺 Austrália
    CountryDocument(
      id: 9,
      countryName: 'Austrália',
      documentName: 'Tax File Number',
      documentCode: 'TFN',
      countryCode: 'AU',
      phoneDialCode: '+61',
    ),
  ];

  static List<CountryDocument> getAllDocuments() {
    final sorted = List<CountryDocument>.from(documents)..sort((a, b) => a.countryName.toLowerCase().compareTo(b.countryName.toLowerCase()),);
    // Adiciona o passaporte como primeira opção
    return [
      CountryDocument(
        id: 0,
        countryName: 'Passaporte',
        documentName: 'Passaporte',
        documentCode: 'PASSPORT',
        countryCode: 'UN',
        phoneDialCode: '',
      ),
      ...sorted,
    ];
  }

  /// Busca documentos por nome do país ou nome do documento.
  static List<CountryDocument> searchDocuments(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllDocuments().where((doc) {
      return doc.countryName.toLowerCase().contains(lowerQuery) ||
          doc.documentName.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
