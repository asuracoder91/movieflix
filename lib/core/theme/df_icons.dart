import 'package:deviflix/core/core.dart';
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
}
