import 'package:chatting_app/pages/add_modify_schedule_page.dart';
import 'package:chatting_app/provider/schedule_notifier.dart';
import 'package:chatting_app/service/schedule_presenter.dart';
import 'package:chatting_app/utils/constant.dart';
import 'package:chatting_app/utils/schedule_item.dart';
import 'package:chatting_app/utils/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SchedulePage extends HookConsumerWidget {
  static const String title = "Schedule";
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleStream = ref.watch(streamSchedule);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm"),
      ),
      body: scheduleStream.when(
        data: (listSchedule) {
          if (listSchedule.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: listSchedule.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var schedule = listSchedule[index];
                return ScheduleItem(
                  schedule: schedule,
                  onButtonChange: (value, docId) {
                    Map<String, dynamic> isActive = {
                      "isActive": value,
                    };
                    ref.watch(schedulePresenter).updateSingleField(isActive, "alarm", docId);
                  },
                  onTap: () {
                    ref.watch(scheduleNotifier.notifier).updateAllData(schedule);
                    Constant.goToPage(context, const AddOrModifySchedulePage());
                  },
                );
              },
            );
          }
        },
        error: (error, stackTrace) {
          return const Center(
            child:Text("Error"),
          );
        },
        loading: () {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ShimmerEffect(width: double.infinity, height: 100),
                SizedBox(height:16),
                ShimmerEffect(width: double.infinity, height: 100),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ref.watch(scheduleNotifier.notifier).resetAllData();
          Constant.goToPage(context, const AddOrModifySchedulePage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
