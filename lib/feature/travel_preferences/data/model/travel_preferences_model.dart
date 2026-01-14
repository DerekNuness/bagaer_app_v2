import 'package:bagaer/feature/travel_preferences/domain/entities/travel_preferences_entity.dart';

class TravelPreferenceModel extends TravelPreference {
  const TravelPreferenceModel({
    required super.id,
    required super.category,
    required super.emoji,
  });

  factory TravelPreferenceModel.fromJson(Map<String, dynamic> json) {
    return TravelPreferenceModel(
      id: json['id'],
      category: json['category'],
      emoji: json['emoji'],
    );
  }
}