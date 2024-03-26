import 'package:chatting_app/service/firestore_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreService = Provider<FirestoreService>((ref) {
  return FirestoreService.instance;
});