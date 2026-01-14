import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';

class MealPreferencesModel extends MealPreference {
  const MealPreferencesModel({
    required super.id,
    required super.category,
    required super.emoji,
  });

  factory MealPreferencesModel.fromJson(Map<String, dynamic> json) {
    return MealPreferencesModel(
      id: json['id'],
      category: json['category'],
      emoji: json['emoji'],
    );
  }
}