import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

/// A wrapper arround a [DocumentSnapshot] that manages data serialization.
class TypedDocumentSnapshot<T> {
  /// The reference to the underlying snapshot.
  final DocumentSnapshot snapshot;

  /// Gets the deserialized value.
  final T value;

  /// Returns the ID of the snapshot's document
  String get documentID => snapshot.documentID;

  /// Returns `true` if the document exists.
  bool get exists => snapshot.exists;

  TypedDocumentSnapshot({@required this.snapshot, @required this.value});
}
