import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_serialized/firestore_serialized.dart';
import 'package:firestore_serialized/src/query_snapshot.dart';

/// A wrapper arround a [Query] that manages data serialization.
class TypedQuery<T> {
  final Query query;

  /// The serializer used with received and sent data.
  final Serializer<T> serializer;

  TypedQuery({this.query, this.serializer});

  /// Notifies of query results at this location
  Stream<TypedQuerySnapshot<T>> snapshots() =>
      this.query.snapshots().map((snapshot) => TypedQuerySnapshot<T>(
          snapshot: snapshot, serializer: this.serializer));

  /// Fetch the documents for this query
  Future<TypedQuerySnapshot<T>> getDocuments() async {
    final snapshot = await this.query.getDocuments();
    return TypedQuerySnapshot<T>(
        snapshot: snapshot, serializer: this.serializer);
  }

  /// Creates and returns a new [Query] with additional filter on specified
  /// [field]. [field] refers to a field in a document.
  ///
  /// The [field] may consist of a single field name (referring to a top level
  /// field in the document), or a series of field names seperated by dots '.'
  /// (referring to a nested field in the document).
  ///
  /// Only documents satisfying provided condition are included in the result
  /// set.
  TypedQuery<T> where(
    String field, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    bool isNull,
  }) =>
      TypedQuery<T>(
          query: this.query.where(
                field,
                isEqualTo: isEqualTo,
                isLessThan: isLessThan,
                isLessThanOrEqualTo: isLessThanOrEqualTo,
                isGreaterThan: isGreaterThan,
                isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                arrayContains: arrayContains,
                isNull: isNull,
              ),
          serializer: this.serializer);

  /// Creates and returns a new [Query] that's additionally sorted by the specified
  /// [field].
  TypedQuery<T> orderBy(String field, {bool descending = false}) =>
      TypedQuery<T>(
          query: this.query.orderBy(field, descending: descending),
          serializer: this.serializer);

  /// Takes a list of [values], creates and returns a new [Query] that starts after
  /// the provided fields relative to the order of the query.
  ///
  /// The [values] must be in order of [orderBy] filters.
  ///
  /// Cannot be used in combination with [startAt].
  TypedQuery<T> startAfter(List<dynamic> values) => TypedQuery<T>(
      query: this.query.startAfter(values), serializer: this.serializer);

  /// Takes a list of [values], creates and returns a new [Query] that starts at
  /// the provided fields relative to the order of the query.
  ///
  /// The [values] must be in order of [orderBy] filters.
  ///
  /// Cannot be used in combination with [startAfter].
  TypedQuery<T> startAt(List<dynamic> values) => TypedQuery<T>(
      query: this.query.startAt(values), serializer: this.serializer);

  /// Takes a list of [values], creates and returns a new [Query] that ends at the
  /// provided fields relative to the order of the query.
  ///
  /// The [values] must be in order of [orderBy] filters.
  ///
  /// Cannot be used in combination with [endBefore].
  TypedQuery<T> endAt(List<dynamic> values) => TypedQuery<T>(
      query: this.query.endAt(values), serializer: this.serializer);

  /// Takes a list of [values], creates and returns a new [Query] that ends before
  /// the provided fields relative to the order of the query.
  ///
  /// The [values] must be in order of [orderBy] filters.
  ///
  /// Cannot be used in combination with [endAt].
  TypedQuery<T> endBefore(List<dynamic> values) => TypedQuery<T>(
      query: this.query.endBefore(values), serializer: this.serializer);

  /// Creates and returns a new Query that's additionally limited to only return up
  /// to the specified number of documents.
  TypedQuery<T> limit(int length) => TypedQuery<T>(
      query: this.query.limit(length), serializer: this.serializer);
}
