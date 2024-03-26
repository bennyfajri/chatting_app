import 'package:chatting_app/models/schedule.dart';
import 'package:chatting_app/provider/firestore_service_provider.dart';
import 'package:chatting_app/service/firestore_services.dart';
import 'package:chatting_app/utils/auth_provider.dart';
import 'package:chatting_app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:chatting_app/utils/exceptions/firebase_exceptions.dart';
import 'package:chatting_app/utils/exceptions/format_exceptions.dart';
import 'package:chatting_app/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulePresenter {
  final FirebaseAuth auth;
  final FirestoreService _firestoreService;

  SchedulePresenter(this._firestoreService, this.auth);

  Future<void> inputSchedule(Schedule schedule) async {
    var newSchedule = schedule;
    newSchedule.userId = auth.currentUser?.uid ?? "";

    return await _firestoreService.addDocument(
      path: "alarm",
      data: newSchedule.toMap(),
    );
  }

  Future<void> updateSchedule(Schedule schedule) async {
    return await _firestoreService.updateData(
      path: "alarm",
      id: schedule.id,
      data: schedule.toMap(),
    );
  }

  Future<void> updateSingleField(
      Map<String, dynamic> json,
      String path,
      String docId
      ) async {
    _firestoreService.updateSingleField(
      path: path,
      json: json,
      id: docId,
    );
  }

  Future<void> deleteSchedule(String docId) async {
    try {
      await FirebaseFirestore.instance.collection("alarm").doc(docId).delete();
    }on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }
}

final schedulePresenter = Provider((ref) =>
    SchedulePresenter(ref.watch(fireStoreService), ref.watch(userProvider)));

final streamSchedule = StreamProvider.autoDispose<List<Schedule>>((ref) {
  return ref.watch(fireStoreService).collectionStream(
        path: "alarm",
        queryBuilder: (query) => query.where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        ),
        builder: (data, documentId) => Schedule.fromMap(data, documentId),
      );
});
