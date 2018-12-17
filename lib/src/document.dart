import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/src/collection.dart';
import 'package:firestore_serialized/src/serializer.dart';
import 'package:firestore_serialized/src/snapshot.dart';
import 'package:meta/meta.dart';

/// A wrapper arround a [DocumentReference] that manages data serialization.
class TypedDocumentReference<T> {
  /// The reference to the underlying document reference.
  final DocumentReference reference;

  /// The serializer used with received and sent data.
  final Serializer<T> serializer;

  /// Slash-delimited path representing the database location of this query.
  String get path => reference.path;

  /// This document's given or generated ID in the collection.
  String get documentID => reference.documentID;

  TypedDocumentReference({@required this.reference, @required this.serializer});

  @override
  bool operator ==(dynamic o) =>
      o is TypedDocumentReference<T> && o.reference == o.reference;

  @override
  int get hashCode => this.reference.hashCode;

  /// Writes to the document referred to by the underlying [DocumentReference].
  ///
  /// If the document does not yet exist, it will be created.
  ///
  /// If [merge] is true, the provided data will be merged into an
  /// existing document instead of overwriting.
  Future<void> setData(T data, {bool merge = false}) {
    final map = this.serializer.serialize(data);
    return this.reference.setData(map, merge: merge);
  }

  /// Updates fields in the document referred to by this [TypedDocumentReference].
  ///
  /// Values in [data] may be of any supported Firestore type as well as
  /// special sentinel [FieldValue] type.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> updateData(T data) {
    final map = this.serializer.serialize(data);
    return this.reference.updateData(map);
  }

  /// Reads the document referenced by this [TypedDocumentReference].
  ///
  /// If no document exists, the read will return null.
  Future<TypedDocumentSnapshot<T>> get() async {
    final snapshot = await this.reference.get();
    final value = serializer.deserialize(snapshot.data);
    return TypedDocumentSnapshot<T>(snapshot: snapshot, value: value);
  }

  /// Deletes the document referred to by this [TypedDocumentReference].
  Future<void> delete() => this.reference.delete();

  /// Returns the reference of a collection contained inside of this
  /// document.
  TypedCollectionReference<Child> collection<Child>(String collectionPath,
      {Serializer<Child> serializer}) {
    final childReference = this.reference.collection(collectionPath);
    return TypedCollectionReference(
        reference: childReference,
        serializer: serializer ?? this.serializer.firestore.serializer<T>());
  }

  /// Notifies of documents at this location
  Stream<TypedDocumentSnapshot<T>> snapshots() {
    return this.reference.snapshots().map((s) => TypedDocumentSnapshot(
        snapshot: s, value: serializer.deserialize(s.data)));
  }
}
