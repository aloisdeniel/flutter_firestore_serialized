import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/firestore_serialized.dart';
import 'package:firestore_serialized/src/serializer.dart';
import 'package:meta/meta.dart';

Type _typeOf<T>() => T;

/// A wrapper arround a [Firestore] that manages data serialization.
class TypedFirestore {
  /// The global instance for querying default serializers.
  static final TypedFirestore instance =
      TypedFirestore(firestore: Firestore.instance);

  final Firestore firestore;

  TypedFirestore({@required this.firestore});

  Map<Type, dynamic> _serializers = {};

  /// Gets a [TypedCollectionReference] for the specified Firestore path.
  TypedCollectionReference<T> collection<T>(String path,
          {Serializer<T> serializer}) =>
      TypedCollectionReference<T>(
          reference: this.firestore.collection(path), serializer: serializer ?? this.serializer<T>());

  /// Gets a [TypedDocumentReference] for the specified Firestore path.
  TypedDocumentReference<T> document<T>(String path,
          {Serializer<T> serializer}) =>
      TypedDocumentReference<T>(
          reference: this.firestore.document(path), serializer: serializer ?? this.serializer<T>());

  /// Registers a serializer for [T].
  void registerSerializer<T>(Serializer<T> serializer) {
    _serializers[_typeOf<T>()] = serializer;
  }

  /// Registers a serializer for [T] from [deserialize] and [serialize] methods.
  void register<T>(Deserialize<T> deserialize, Serialize<T> serialize) {
    this.registerSerializer<T>(Serializer<T>(this, deserialize, serialize));
  }

  /// Gets the serializer for [T].
  Serializer<T> serializer<T>() {
    final deserializer = this._serializers[_typeOf<T>()] as Serializer<T>;
    assert(deserializer != null,
        "Not serializer found for type $T. Be sure to register one before use.");
    return deserializer;
  }
}
