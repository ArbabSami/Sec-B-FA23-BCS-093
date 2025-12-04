import 'package:flutter/material.dart';

/// ------------------------------------------------------
/// APP CONSTANTS (Colors, Styles, Decorations)
/// ------------------------------------------------------

// Card Colors
const kActiveCardColor = Colors.teal;
const kInactiveCardColor = Color(0xFFE0E0E0);

// Icon Colors
const kActiveIconColor = Colors.white;
const kInactiveIconColor = Colors.black;

// Border Radius
const double kCardBorderRadius = 12.0;

// Shadows
const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Colors.black12,
    blurRadius: 4,
    offset: Offset(0, 3),
  ),
];

/// ------------------------------------------------------
/// TEXT STYLES
/// ------------------------------------------------------

// Label Style used in TextFields → kLabel
const TextStyle kLabel = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

// Hint Text Style
const TextStyle kHintStyle = TextStyle(
  fontSize: 14,
  color: Colors.black54,
);

// Gender Card Text
const TextStyle kGenderTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

/// Result Screen Text Styles
const TextStyle kResultTitleStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const TextStyle kResultSubtitleStyle = TextStyle(
  fontSize: 18,
);

const TextStyle kAdviceTextStyle = TextStyle(
  fontSize: 16,
);
