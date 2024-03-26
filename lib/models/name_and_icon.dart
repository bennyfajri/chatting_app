import 'package:flutter/material.dart';

class NameAndIcon {
  String name;
  String icon;
  Color? backgroundColor;

  NameAndIcon({
    required this.name,
    required this.icon,
    this.backgroundColor,
  });
}
