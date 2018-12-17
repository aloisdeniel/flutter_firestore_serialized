import 'package:firestore_serialized/src/firestore.dart';

/// Converts a map to an [T] instance.
typedef T Deserialize<T>(Map<String, dynamic> map);

/// Converts a [T] instance to a map.
typedef Map<String, dynamic> Serialize<T>(T value);

/// A map two way serializer for [T].
class Serializer<T> {
  final TypedFirestore firestore;

  /// Converts a map to an [T] instance.
  final Deserialize<T> deserialize;

  /// Converts a [T] instance to a map.
  final Serialize<T> serialize;

  Serializer(this.firestore, this.deserialize, this.serialize);
}
