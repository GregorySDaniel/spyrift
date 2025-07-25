import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  final TextTheme baseTextTheme = Theme.of(context).textTheme;
  final TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  final TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  final TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok<T>(value);

  factory Result.error(Exception error) => Error<T>(error);

  factory Result.okEmpty() => OkEmpty<T>();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class OkEmpty<T> extends Result<T> {
  const OkEmpty();
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final Exception error;
}
