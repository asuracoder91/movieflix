import 'package:deviflix/core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class DFIcons {
  static const FaIcon bars = FaIcon(
    FontAwesomeIcons.bars,
    color: DFColors.iconColor,
  );
  static const FaIcon search = FaIcon(
    FontAwesomeIcons.magnifyingGlass,
    color: DFColors.iconColor,
  );
  static const FaIcon back = FaIcon(
    FontAwesomeIcons.chevronLeft,
    color: Color(0xFFC9C9C9),
  );

  static const IconData arrowUp = Icons.keyboard_arrow_up;
}
