import 'package:coup/core/constants/sizing.dart';
import 'package:flutter/material.dart';

class CommonConstants {
  const CommonConstants._();

  static double BORDER_WIDTH_BOTTOMBAR = 0.5;
  static double MAX_PLAYERS = 6;
  static int NAME_MAX_LENGTH = 20;

  static BorderRadius get borderRadius8 => BorderRadius.all(Radius.circular(Sizing.s8));
  static BorderRadius get borderRadius16 => BorderRadius.all(Radius.circular(Sizing.s16));
  static BorderRadius get borderRadius20 => BorderRadius.all(Radius.circular(Sizing.s20));
}
