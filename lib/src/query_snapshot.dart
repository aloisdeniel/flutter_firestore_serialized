import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/src/document_change.dart';
import 'package:firestore_serialized/src/serializer.dart';
import 'package:firestore_serialized/src/snapshot.dart';
import 'package:meta/meta.dart';

/// A wrapper arround a [QuerySnapshot] that manages data serialization.
class TypedQuerySnapshot<T> {
  TypedQuerySnapshot({@required this.snapshot, Serializer<T> serializer})
      : documents = snapshot.documents
            .map((s) => TypedDocumentSnapshot<T>(
                snapshot: s, value: serializer.deserialize(s.data)))
            .toList(),
        documentChanges = snapshot.documentChanges
            .map((c) =>
                TypedDocumentChange<T>(change: c, serializer: serializer))
            .toList();

  /// The reference to the underlying query snapshot.
  final QuerySnapshot snapshot;

  /// Gets a list of all the documents included in this snapshot
  final List<TypedDocumentSnapshot<T>> documents;

  /// An array of the documents that changed since the last snapshot. If this
  /// is the first snapshot, all documents will be in the list as Added changes.
  final List<TypedDocumentChange<T>> documentChanges;
}
