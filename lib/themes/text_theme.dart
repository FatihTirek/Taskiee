// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  final Font font;

  const AppTextTheme(this.font);

  static const _rubik = 'Rubik';
  static const _kanit = 'Kanit';
  static const _roboto = 'Roboto';
  static const _ubuntu = 'Ubuntu';
  static const _prompt = 'Prompt';
  static const _ptSans = 'PT Sans';
  static const _workSans = 'Work Sans';
  static const _openSans = 'Open Sans';
  static const _firaSans = 'Fira Sans';
  static const _righteous = 'Righteous';
  static const _quickSand = 'Quicksand';
  static const _sourceSansPro = 'Source Sans Pro';

  TextStyle _getStyle() {
    switch (font) {
      case Font.Roboto:
        return GoogleFonts.getFont(_roboto, fontWeight: FontWeight.w500);
      case Font.PtSans:
        return GoogleFonts.getFont(_ptSans, fontWeight: FontWeight.w600);
      case Font.Rubik:
        return GoogleFonts.getFont(_rubik, fontWeight: FontWeight.w500);
      case Font.SourceSansPro:
        return GoogleFonts.getFont(_sourceSansPro, fontWeight: FontWeight.w600);
      case Font.FiraSans:
        return GoogleFonts.getFont(_firaSans, fontWeight: FontWeight.w500);
      case Font.OpenSans:
        return GoogleFonts.getFont(_openSans, fontWeight: FontWeight.w600);
      case Font.QuickSand:
        return GoogleFonts.getFont(_quickSand, fontWeight: FontWeight.w600);
      case Font.Ubuntu:
        return GoogleFonts.getFont(_ubuntu, fontWeight: FontWeight.w400);
      case Font.Righteous:
        return GoogleFonts.getFont(_righteous, fontWeight: FontWeight.w500);
      case Font.WorkSans:
        return GoogleFonts.getFont(_workSans, fontWeight: FontWeight.w500);
      case Font.Prompt:
        return GoogleFonts.getFont(_prompt, fontWeight: FontWeight.w400);
      case Font.Kanit:
        return GoogleFonts.getFont(_kanit, fontWeight: FontWeight.w500);
    }
  }

  TextStyle _headline1(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 20);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 20);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 20);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 19);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 21);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 20);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 19);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 19.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 20);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 20);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 20);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 21);
    }
  }

  TextStyle _headline2(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 19);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 19);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 19);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 18);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 20);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 19);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 18);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 18.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 19);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 19);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 19);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 20);
    }
  }

  TextStyle _headline3(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 18);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 18);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 18);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 17);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 19);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 18);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 17);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 17.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 18);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 18);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 18);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 17);
    }
  }

  TextStyle _headline4(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 17);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 17);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 17);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 16);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 18);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 17);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 16);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 16.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 17);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 17);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 17);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 18);
    }
  }

  TextStyle _bodyText1(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 16);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 16);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 16);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 15);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 17);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 16);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 15);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 15.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 16);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 16);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 16);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 17);
    }
  }

  TextStyle _bodyText2(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 15);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 15);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 15);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 14);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 16);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 15);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 14);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 14.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 15);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 15);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 15);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 16);
    }
  }

  TextStyle _subtitle1(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 14);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 14);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 14);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 13);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 15);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 14);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 13);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 13.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 14);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 14);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 14);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 15);
    }
  }

  TextStyle _subtitle2(TextStyle textStyle) {
    switch (font) {
      case Font.Roboto:
        return textStyle.copyWith(fontSize: 13);
      case Font.Ubuntu:
        return textStyle.copyWith(fontSize: 13);
      case Font.PtSans:
        return textStyle.copyWith(fontSize: 13);
      case Font.Rubik:
        return textStyle.copyWith(fontSize: 12);
      case Font.SourceSansPro:
        return textStyle.copyWith(fontSize: 14);
      case Font.FiraSans:
        return textStyle.copyWith(fontSize: 13);
      case Font.OpenSans:
        return textStyle.copyWith(fontSize: 12);
      case Font.Righteous:
        return textStyle.copyWith(fontSize: 12.5);
      case Font.WorkSans:
        return textStyle.copyWith(fontSize: 13);
      case Font.Prompt:
        return textStyle.copyWith(fontSize: 14);
      case Font.QuickSand:
        return textStyle.copyWith(fontSize: 13);
      case Font.Kanit:
        return textStyle.copyWith(fontSize: 13);
    }
  }

  ThemeData finalizeTheme(ThemeData themeData) {
    final textStyle = _getStyle();
    final color = themeData.colorScheme.brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return themeData.copyWith(
      textTheme: TextTheme(
        headline1: _headline1(textStyle).copyWith(color: color),
        headline2: _headline2(textStyle).copyWith(color: color),
        headline3: _headline3(textStyle).copyWith(color: color),
        headline4: _headline4(textStyle).copyWith(color: color),
        bodyText1: _bodyText1(textStyle).copyWith(color: color),
        bodyText2: _bodyText2(textStyle).copyWith(color: color),
        subtitle1: _subtitle1(textStyle).copyWith(color: color),
        subtitle2: _subtitle2(textStyle).copyWith(color: color),
      ),
    );
  }
}
