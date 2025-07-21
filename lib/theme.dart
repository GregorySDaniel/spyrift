import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8f4c38),
      surfaceTint: Color(0xff8f4c38),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdbd1),
      onPrimaryContainer: Color(0xff723523),
      secondary: Color(0xff77574e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdbd1),
      onSecondaryContainer: Color(0xff5d4037),
      tertiary: Color(0xff6c5d2f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff5e1a7),
      onTertiaryContainer: Color(0xff534619),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff231917),
      onSurfaceVariant: Color(0xff53433f),
      outline: Color(0xff85736e),
      outlineVariant: Color(0xffd8c2bc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2b),
      inversePrimary: Color(0xffffb5a0),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff3a0b01),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff723523),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff2c150f),
      secondaryFixedDim: Color(0xffe7bdb2),
      onSecondaryFixedVariant: Color(0xff5d4037),
      tertiaryFixed: Color(0xfff5e1a7),
      onTertiaryFixed: Color(0xff231b00),
      tertiaryFixedDim: Color(0xffd8c58d),
      onTertiaryFixedVariant: Color(0xff534619),
      surfaceDim: Color(0xffe8d6d2),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ed),
      surfaceContainer: Color(0xfffceae5),
      surfaceContainerHigh: Color(0xfff7e4e0),
      surfaceContainerHighest: Color(0xfff1dfda),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece7),
      surfaceTint: Color(0xffffb5a0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaf98),
      onPrimaryContainer: Color(0xff1e0300),
      secondary: Color(0xffffece7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe3b9ae),
      onSecondaryContainer: Color(0xff190603),
      tertiary: Color(0xffffefc4),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd4c289),
      onTertiaryContainer: Color(0xff100b00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a110f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece7),
      outlineVariant: Color(0xffd4beb8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfda),
      inversePrimary: Color(0xff743624),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff280500),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe7bdb2),
      onSecondaryFixedVariant: Color(0xff200b06),
      tertiaryFixed: Color(0xfff5e1a7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd8c58d),
      onTertiaryFixedVariant: Color(0xff171100),
      surfaceDim: Color(0xff1a110f),
      surfaceBright: Color(0xff5a4d4a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff271d1b),
      surfaceContainer: Color(0xff392e2b),
      surfaceContainerHigh: Color(0xff443936),
      surfaceContainerHighest: Color(0xff504441),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
