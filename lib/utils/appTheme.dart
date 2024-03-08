// app_colors.dart

import 'package:flutter/material.dart';

//Font sizes following by tailwind, https://tailwindcss.com/docs/font-size
const double textXs = 12.0;
const double textSm = 14.0;
const double textMd = 16.0;
const double textLg = 18.0;
const double textXl = 20.0;
const double text2xl = 24.0;
const double text3xl = 30.0;
const double text4xl = 36.0;
const double text5xl = 48.0;

const Color primary = Colors.red;
//const Color primaryVariant = Colors.indigo;
const Color secondary = Colors.orange;
//const Color secondaryVariant = Colors.deepOrange;
const Color tertiary = Color.fromARGB(255, 0, 174, 38);
const Color surface = Colors.white;
const Color background = Color.fromARGB(255, 255, 255, 255);
const Color error = Colors.red;
const Color onPrimary = Colors.white;
const Color onSecondary = Color.fromARGB(255, 255, 255, 255);
const Color onSurface = Color.fromARGB(255, 82, 82, 82);
const Color onBackground = Colors.white;
const Color onError = Colors.white;
const Color borderColor = Color.fromARGB(255, 230, 230, 230);

final ThemeData appTheme = ThemeData(
  fontFamily: 'Roboto',
  colorScheme: const ColorScheme(
    primary: primary,
    //  primaryVariant: primaryVariant,
    secondary: secondary,
    //  secondaryVariant: secondaryVariant,

    tertiary: tertiary,
    surface: surface,
    background: background,
    error: error,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onSurface: onSurface,
    onBackground: onBackground,
    onError: onError,
    brightness: Brightness.light,
  ),
);
