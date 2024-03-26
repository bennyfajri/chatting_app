import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> addDocument({
    required String path,
    String? id,
    Map<String, dynamic>? data,
  }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(path);
    await users.doc(id).set(data);
  }

  Future<void> updateSingleField(
      {required String path,
      required String? id,
      required Map<String, dynamic> json}) async {
    try {
      await FirebaseFirestore.instance.collection(path).doc(id).update(json);
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  //function to accept array of data using batch
  Future<void> addDocuments({
    required String path,
    List<Map<String, dynamic>>? data,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference collection =
        FirebaseFirestore.instance.collection(path);
    for (var element in data!) {
      batch.set(collection.doc(), element);
    }

    await batch.commit();
  }

  Future<void> updateData({
    required String path,
    String? id,
    Map<String, dynamic>? data,
  }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(path);
    if (data != null) {
      await users.doc(id).update(data);
    } else {
      print('user null');
    }
  }

  Future<void> deleteData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    DocumentReference users = FirebaseFirestore.instance.doc(path);
    print('$path; $data');
    // Call the user's CollectionReference to add a new user
    await users.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshotss) {
      final result = snapshotss.docs
          .map((snapshot) {
            final data = snapshot.data() as Map<String, dynamic>;
            return builder(data, snapshot.id);
          })
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> collectionStream2<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    // Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    final query = FirebaseFirestore.instance.collection(path);
    // if (queryBuilder != null) {
    //   query = queryBuilder(query);
    // }

    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required String id,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final docRef = FirebaseFirestore.instance.collection(path).doc(id);
    final snapshot = docRef.snapshots();

    return snapshot.map((event) {
      // var data = event.data() as Map<String, dynamic>;
      return builder(event.data(), event.id);
    });
    // docRef.get().then((value) {
    //   builder(value.data(), value.id);
    // });
  }

  Future<List<T>> getDocumentList<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    QuerySnapshot<Object?> snapshot = await query.get();

    List<T> result = snapshot.docs.map((doc) {
      final data = doc.data();
      return builder(data as Map<String, dynamic>, doc.id);
    }).toList();

    if (sort != null) {
      result.sort(sort);
    }

    return result;
  }
}
