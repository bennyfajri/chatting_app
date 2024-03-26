import 'package:chatting_app/models/schedule.dart';
import 'package:chatting_app/provider/is_loading_provider.dart';
import 'package:chatting_app/provider/schedule_notifier.dart';
import 'package:chatting_app/service/schedule_presenter.dart';
import 'package:chatting_app/utils/constant.dart';
import 'package:chatting_app/utils/custom_dialog.dart';
import 'package:chatting_app/utils/loaders.dart';
import 'package:chatting_app/utils/loading_button.dart';
import 'package:chatting_app/utils/my_appbar.dart';
import 'package:chatting_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class AddOrModifySchedulePage extends HookConsumerWidget {
  const AddOrModifySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingUpload);
    final presenter = ref.watch(schedulePresenter);
    final sNotifier = ref.watch(scheduleNotifier);

    final dateDifference = useState(
      Constant.getDateDifference(sNotifier.time, DateTime.now()),
    );

    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          "Add Alarm",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        showBackArrow: true,
        actions: [
          if (sNotifier.id?.isNotEmpty == true)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                customDialog(
                  context: context,
                  icon: Icons.warning_amber_rounded,
                  title: "Alert",
                  message: "Are you sure want to delete this schedule",
                  positiveButton: "Yes",
                  negativeButton: "Cancel",
                  onPositiveClicked: () async {
                    presenter.deleteSchedule(sNotifier.id ?? "");
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  onNegativeClicked: () {
                    Navigator.pop(context);
                  },
                );
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            /// Center title
            Center(
              child: Text(
                "Scheduled in${dateDifference.value}",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.apply(color: Colors.black87.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 16),

            /// Time Picker
            TimePickerSpinner(
              is24HourMode: true,
              normalTextStyle: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.apply(color: Colors.black87.withOpacity(0.4)),
              highlightedTextStyle: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.apply(color: Theme.of(context).colorScheme.primary),
              spacing: 90,
              itemWidth: 65,
              time: sNotifier.time,
              alignment: Alignment.center,
              isForce2Digits: true,
              onTimeChange: (time) {
                final now = DateTime.now();
                sNotifier.time = time;
                dateDifference.value = Constant.getDateDifference(
                  now,
                  time.isBefore(now) ? time.add(const Duration(days: 1)) : time,
                );
              },
            ),
            const SizedBox(height: 24),

            /// Alarm type
            ScheduleItems(
              title: Text("Alarm type"),
              trailingText: sNotifier.type,
              onTap: () {
                Constant.buildListBottomSheet(
                  context,
                  "Alarm type",
                  ListView.builder(
                      itemCount: Strings.listScheduleType.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final scheduleType = Strings.listScheduleType[index];
                        return InkWell(
                          onTap: () {
                            ref
                                .watch(scheduleNotifier.notifier)
                                .updateType(scheduleType.name);
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            leading: Iconify(
                              scheduleType.icon,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              scheduleType.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: const Icon(Icons.navigate_next),
                          ),
                        );
                      }),
                );
              },
            ),

            const SizedBox(height: 16),
            LoadingSaveButton(
              text: "Save",
              isLoading: isLoading,
              onPressed: () async {
                if (sNotifier.type.isEmpty) {
                  Loaders.warningSnackBar(
                    context: context,
                    title: "Attention",
                    message: "Choose alarm type first",
                  );
                } else {
                  ref.read(isLoadingUpload.notifier).state = true;
                  final Schedule schedule = Schedule(
                      id: sNotifier.id,
                      type: sNotifier.type,
                      time: sNotifier.time,
                      isActive: true);

                  if (sNotifier.id?.isNotEmpty == true) {
                    await presenter.updateSchedule(schedule);
                  } else {
                    await presenter.inputSchedule(schedule);
                  }

                  if (context.mounted) {
                    Loaders.successSnackBar(
                      context: context,
                      title: "Success",
                      message: "Your data has been recorded",
                    );
                    ref.read(isLoadingUpload.notifier).state = false;
                    await Future.delayed(const Duration(seconds: 1));
                    ref.watch(scheduleNotifier.notifier).resetAllData();
                    if (context.mounted) Navigator.pop(context);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class ScheduleItems extends StatelessWidget {
  const ScheduleItems({
    super.key,
    required this.title,
    required this.trailingText,
    required this.onTap,
  });

  final String trailingText;
  final Widget title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: ListTile(
          title: title,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailingText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 2),
              const Icon(Icons.navigate_next)
            ],
          ),
        ),
      ),
    );
  }
}
