import 'dart:io';

/// Represents an experience in the application.
class Experience {
  /// The unique identifier of the experience.
  final int? id;

  /// A textual description of the experience.
  final String description;

  /// The first photo associated with the experience.
  final File? photo1;

  /// The second photo associated with the experience.
  final File? photo2;

  /// The third photo associated with the experience.
  final File? photo3;

  /// The identifier of the stop this experience belongs to.
  final int? stopId;

  /// Creates an instance of [Experience].
  Experience({
    this.id,
    required this.description,
    this.photo1,
    this.photo2,
    this.photo3,
    this.stopId,
  });

  /// Converts this [Experience] object into a [Map].
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'description': description,
      'photo1': photo1?.path,
      'photo2': photo2?.path,
      'photo3': photo3?.path,
      'stopId': stopId,
    };
    return map;
  }

  /// Creates an [Experience] from a [Map].
  static Experience fromMap(Map<String, Object?> map) {
    String? asString(Object? v) => v is String ? v : v?.toString();
    File? fileFrom(Object? v) {
      final p = asString(v);
      if (p == null || p.isEmpty) return null;
      return File(p);
    }

    int? asInt(Object? v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return Experience(
      id: asInt(map['id']),
      description: (asString(map['description']) ?? ''),
      photo1: fileFrom(map['photo1']),
      photo2: fileFrom(map['photo2']),
      photo3: fileFrom(map['photo3']),
      stopId: asInt(map['stopId']),
    );
  }
}
