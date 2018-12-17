import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/src/document.dart';
import 'package:firestore_serialized/src/firestore.dart';
import 'package:firestore_serialized/src/query.dart';
import 'package:meta/meta.dart';

import 'serializer.dart';

/// A wrapper arround a [CollectionReference] that manages data serialization.
class TypedCollectionReference<T> extends TypedQuery<T> {
  /// The reference to the underlying collection reference.
  final CollectionReference reference;

  /// ID of the referenced collection.
  String get id => this.reference.id;

  /// A string containing the slash-separated path to this  CollectionReference
  /// (relative to the root of the database).
  String get path => this.reference.path;

  TypedCollectionReference({
    @required this.reference,
    @required Serializer<T> serializer,
  }) : super(query: reference, serializer: serializer);

  /// Returns a `TypedDocumentReference` with the provided path.
  ///
  /// If no [path] is provided, an auto-generated ID is used.
  ///
  /// The unique key generated is prefixed with a client-generated timestamp
  /// so that the resulting list will be chronologically-sorted.
  TypedDocumentReference<T> document(String path) {
    final docReference = this.reference.document(path);
    return TypedDocumentReference<T>(
        reference: docReference, serializer: this.serializer);
  }

  /// Returns a `TypedDocumentReference` with an auto-generated ID, after
  /// populating it with provided [data].
  ///
  /// The unique key generated is prefixed with a client-generated timestamp
  /// so that the resulting list will be chronologically-sorted.
  Future<TypedDocumentReference<T>> add(T data) async {
    final map = this.serializer.serialize(data);
    final docReference = await this.reference.add(map);
    return TypedDocumentReference<T>(
        reference: docReference, serializer: this.serializer);
  }
}
