import 'package:flutter/material.dart';

// Color definitions for tajweed rules
const Color QALQALA_COLOR_USER = Colors.blue;
const Color GHUNNA_COLOR_USER = Colors.green;
const Color IKHFAA_COLOR_USER = Colors.green;
const Color IDGHAM_COLOR_USER = Colors.grey;
const Color PROLONGING_2_VOWELS_COLOR_USER = Color(0xFFFFAB40); // Light Orange

// TajweedRule enum with priorities and colors
enum TajweedRule {
  qalqala(6, color: QALQALA_COLOR_USER, darkThemeColor: QALQALA_COLOR_USER),
  ghunna(8, color: GHUNNA_COLOR_USER, darkThemeColor: GHUNNA_COLOR_USER),
  ikhfaa(3, color: IKHFAA_COLOR_USER, darkThemeColor: IKHFAA_COLOR_USER),
  idghamWithGhunna(4, color: IDGHAM_COLOR_USER, darkThemeColor: IDGHAM_COLOR_USER),
  idghamWithoutGhunna(7, color: IDGHAM_COLOR_USER, darkThemeColor: IDGHAM_COLOR_USER),
  prolonging(9, color: PROLONGING_2_VOWELS_COLOR_USER, darkThemeColor: PROLONGING_2_VOWELS_COLOR_USER),
  alefTafreeq(10, color: IDGHAM_COLOR_USER, darkThemeColor: IDGHAM_COLOR_USER),
  hamzatulWasli(11, color: IDGHAM_COLOR_USER, darkThemeColor: IDGHAM_COLOR_USER),
  LAFZATULLAH(1, color: null, darkThemeColor: null),
  izhar(2, color: null, darkThemeColor: null),
  iqlab(5, color: null, darkThemeColor: null),
  none(100, color: null);

  const TajweedRule(this.priority, {required Color? color, Color? darkThemeColor})
      : _color = color,
        _darkThemeColor = darkThemeColor ?? color;

  final int priority;
  final Color? _color;
  final Color? _darkThemeColor;

  Color? color(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? _darkThemeColor : _color;
  }
}

// Class to represent a tajweed token
class TajweedToken implements Comparable<TajweedToken> {
  final TajweedRule rule;
  final String text;
  final int startIx;
  final int endIx;
  final String? matchGroup;

  TajweedToken(
    this.rule,
    this.text,
    this.startIx,
    this.endIx,
    this.matchGroup,
  );

  @override
  int compareTo(TajweedToken other) {
    if (startIx != other.startIx) {
      return startIx.compareTo(other.startIx);
    }
    return other.rule.priority.compareTo(rule.priority);
  }
}

// Class to represent a word with tajweed tokens
class TajweedWord {
  final List<TajweedToken> tokens = [];
}

class Tajweed {
  static const LAFZATULLAH =
      r'(?<LAFZATULLAH>(\u0627|\u0671)?\u0644\p{M}*\u0644\u0651\p{M}*\u0647\p{M}*(' +
          smallHighLetters +
          r'?\u0020|$))';

  static const smallHighLetters =
      r'(\u06DA|\u06D6|\u06D7|\u06D8|\u06D9|\u06DB|\u06E2|\u06ED)';
  static const optionalSmallHighLetters = '$smallHighLetters?';
  static const smallHighLettersBetweenWords = smallHighLetters + r'?\u0020*';
  static const fathaKasraDammaWithoutTanvin = r'(\u064F|\u064E|\u0650)';
  static const fathaKasraDammaWithTanvin =
      r'(\u064B|\u064C|\u064D|\u08F0|\u08F1|\u08F2)';
  static const fathaKasraDammaWithOrWithoutTanvin = r'(' +
      fathaKasraDammaWithoutTanvin +
      r'|' +
      fathaKasraDammaWithTanvin +
      r')';
  static const shadda = r'\u0651';
  static const fathaKasraDammaWithTanvinWithOptionalShadda =
      r'(\u0651?' + fathaKasraDammaWithTanvin + r'\u0651?)';
  static const nonReadingCharactersAtEndOfWord =
      r'(\u0627|\u0648|\u0649|\u06E5)?';
  static const higherOrLowerMeem = r'(\u06E2|\u06ED)';
  static const sukoonWithoutGrouping = r'\u0652|\u06E1|\u06DF';
  static const sukoon = '($sukoonWithoutGrouping)';
  static const optionalSukoon = r'(\u0652|\u06E1)?';
  static const noonWithOptionalSukoon = r'(\u0646' + optionalSukoon + r')';
  static const meemWithOptionalSukoon = r'(\u0645' + optionalSukoon + r')';
  static const throatLetters =
      r'(\u062D|\u062E|\u0639|\u063A|\u0627|\u0623|\u0625|\u0647)';
  static const throatLettersWithoutExtensionAlef =
      r'(\u062D|\u062E|\u0639|\u063A|\u0627\p{M}*\p{L}|\u0623|\u0625|\u0647)';
  static const ghunna = r'(?<ghunna>(\u0645|\u0646)\u0651\p{M}*)';
  static const ikhfaaLetters =
      r'(\u0638|\u0641|\u0642|\u0643|\u062A|\u062B|\u062C|\u062F|\u0630|\u0632|\u0633|\u0634|\u0635|\u0636|\u0637)\p{M}*';
  static const ikhfaa_noonSakinAndTanweens =
      r'((?<ikhfaa>(' +
          noonWithOptionalSukoon +
          r'|(\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          r'))' +
          nonReadingCharactersAtEndOfWord +
          smallHighLettersBetweenWords +
          ikhfaaLetters +
          r')';
  static const ikhfaa_meemSakin = r'|<ikhfaa>(' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0628\p{M}*))';
  static const ikhfaa = r'(?<ikhfaa>' + ikhfaa_noonSakinAndTanweens + ikhfaa_meemSakin + r')';
  static const idghamWithGhunna_noonSakinAndTanweens =
      r'(?<idghamWithGhunna>(' +
          noonWithOptionalSukoon +
          r'|(\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          nonReadingCharactersAtEndOfWord +
          r'))' +
          smallHighLettersBetweenWords +
          r'(\u064A|\u06CC|\u0645|\u0646|\u0648)\p{M}*)';
  static const idghamWithGhunna_meemSakin = r'|<idghamWithGhunna>(' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0645\p{M}*\u0651\p{M}*))';
  static const idghamWithGhunna = r'(?<idghamWithGhunna>' + idghamWithGhunna_noonSakinAndTanweens + idghamWithGhunna_meemSakin + r')';
  static const idghamWithoutGhunna_noonSakinAndTanweens =
      r'((?<idghamWithoutGhunna>((\u0646(\u0652|\u06E1)?)|\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          nonReadingCharactersAtEndOfWord +
          r'))' +
          smallHighLettersBetweenWords +
          r'(\u0644|\u0631)\p{M}*)';
  static const idghamWithoutGhunna_shamsiyya =
      r'|<idghamWithoutGhunna>((\u0627|\u0671)\u0644)\p{L}\u0651\p{M}*))';
  static const idghamWithoutGhunna_misleyn =
      r'|<idghamWithoutGhunna>(?:(?!\u0645)(\p{L})))\u0020*\2\u0651)';
  static const idghamWithoutGhunna_mutajaniseyn_1 =
      r'|<idghamWithoutGhunna>[\u0637\u062F\u062A]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0637\u062F\u062A]'
