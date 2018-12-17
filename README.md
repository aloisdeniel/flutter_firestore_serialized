# firestore_serialized

Thin layer on top of Firestore to serialize/deserialize document's data.

## Quickstart

```dart
TypedFirestore.instance.register<User>(User.fromJson, User.toJson);
```

Then use the `Typed...` alternatives from original firestore types.

```dart
final user = TypedFirestore.instance.collection<User>("users").document("john");
final snapshot = await user.get();
print(snapshot.value.lastname);
```

## Roadmap

* Transactions
* Batches