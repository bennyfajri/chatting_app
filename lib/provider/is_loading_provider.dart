import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingUpload = StateProvider<bool>((ref) => false);