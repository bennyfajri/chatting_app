import 'package:chatting_app/models/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleNotifier = NotifierProvider<ScheduleNotifier, Schedule>(ScheduleNotifier.new);

class ScheduleNotifier  extends Notifier<Schedule> {
  @override
  Schedule build() {
    return Schedule.empty();
  }

  void resetAllData() {
    state = Schedule.empty();
  }

  void updateAllData(Schedule schedule) {
    state = schedule;
  }

  void updateId(String id) {
    state = state.copyWith(id: id);
  }

  void updateType(String type) {
    state = state.copyWith(type: type);
  }

  void updateUserId(String userId) {
    state = state.copyWith(userId: userId);
  }

  void updateTime(DateTime time) {
    state = state.copyWith(time: time);
  }
}