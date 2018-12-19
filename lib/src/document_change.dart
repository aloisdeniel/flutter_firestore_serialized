import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/src/serializer.dart';
import 'package:firestore_serialized/src/snapshot.dart';
import 'package:meta/meta.dart';

/// A wrapper arround a [QuerySnapshot] that manages data serialization.
class TypedDocumentChange<T> {
  TypedDocumentChange({this.change, @required Serializer<T> serializer})
      : this.document = TypedDocumentSnapshot<T>(
            snapshot: change.document,
            serializer: serializer);

  final DocumentChange change;

  DocumentChangeType get type => this.change.type;

  int get newIndex => this.change.newIndex;

  int get oldIndex => this.change.oldIndex;

  /// The document affected by this change.
  final TypedDocumentSnapshot<T> document;
}
