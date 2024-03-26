import 'package:chatting_app/models/name_and_icon.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class Strings {
  Strings._();

  static List<NameAndIcon> listScheduleType = [
    NameAndIcon(name: "EATING", icon: MaterialSymbols.fastfood_rounded),
    NameAndIcon(name: "EXCERCISE", icon: Mdi.dumbbell),
    NameAndIcon(name: "MEDICINE", icon: IconParkSolid.medicine_bottle_one),
  ];
}