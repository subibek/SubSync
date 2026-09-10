import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';

class SubSyncTextStyles{

  static FontWeight bold = FontWeight.bold;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight medium = FontWeight.w500;
  static FontWeight regular = FontWeight.w400;

   static TextStyle get displayLg => subSyncTextStyle(fontSize: 180, fontWeight: regular, lineHeight: 188, letterSpacing: -0.05);
  static TextStyle get displayMd => subSyncTextStyle(fontSize: 128, fontWeight: regular, lineHeight: 136, letterSpacing: -0.04);
  static TextStyle get displaySm => subSyncTextStyle(fontSize: 96, fontWeight: regular, lineHeight: 104, letterSpacing: -0.03);

  static TextStyle get heading2xl => subSyncTextStyle(fontSize: 72, fontWeight: regular, lineHeight: 80, letterSpacing: -0.02);
  static TextStyle get headingXl => subSyncTextStyle(fontSize: 60, fontWeight: regular, lineHeight: 68, letterSpacing: -0.018);
  static TextStyle get headingLg => subSyncTextStyle(fontSize: 48, fontWeight: regular, lineHeight: 56, letterSpacing: -0.016);
  static TextStyle get headingMd => subSyncTextStyle(fontSize: 36, fontWeight: regular, lineHeight: 44, letterSpacing: -0.014);
  static TextStyle get headingSm => subSyncTextStyle(fontSize: 30, fontWeight: regular, lineHeight: 38, letterSpacing: -0.013);
  static TextStyle get headingXs => subSyncTextStyle(fontSize: 24, fontWeight: regular, lineHeight: 32, letterSpacing: -0.012);

  static TextStyle get text2xl => subSyncTextStyle(fontSize: 24, fontWeight: regular, lineHeight: 32, letterSpacing: -0.012);
  static TextStyle get textXl => subSyncTextStyle(fontSize: 20, fontWeight: regular, lineHeight: 28, letterSpacing: -0.01);
  static TextStyle get textLg => subSyncTextStyle(fontSize: 18, fontWeight: regular, lineHeight: 24, letterSpacing: -0.008);
  static TextStyle get textMd => subSyncTextStyle(fontSize: 16, fontWeight: regular, lineHeight: 22, letterSpacing: -0.007);
  static TextStyle get textSm => subSyncTextStyle(fontSize: 14, fontWeight: regular, lineHeight: 20, letterSpacing: -0.006);
  static TextStyle get textXs => subSyncTextStyle(fontSize: 12, fontWeight: regular, lineHeight: 16, letterSpacing: -0.005);
  static TextStyle get text2xs => subSyncTextStyle(fontSize: 10, fontWeight: regular, lineHeight: 14, letterSpacing: -0.004);

  static TextStyle get paragraph2xl => subSyncTextStyle(fontSize: 24, fontWeight: regular, lineHeight: 38.4);
  static TextStyle get paragraphXl => subSyncTextStyle(fontSize: 20, fontWeight: regular, lineHeight: 32);
  static TextStyle get paragraphLg => subSyncTextStyle(fontSize: 18, fontWeight: regular, lineHeight: 28.8);
  static TextStyle get paragraphMd => subSyncTextStyle(fontSize: 16, fontWeight: regular, lineHeight: 25.6);
  static TextStyle get paragraphSm => subSyncTextStyle(fontSize: 14, fontWeight: regular, lineHeight: 22.4);
  static TextStyle get paragraphXs => subSyncTextStyle(fontSize: 12, fontWeight: regular, lineHeight: 19.2);

  static TextStyle get label2xl => subSyncTextStyle(fontSize: 20, fontWeight: regular, lineHeight: 28, letterSpacing: 0.1);
  static TextStyle get labelXl => subSyncTextStyle(fontSize: 18, fontWeight: regular, lineHeight: 24, letterSpacing: 0.1);
  static TextStyle get labelLg => subSyncTextStyle(fontSize: 16, fontWeight: regular, lineHeight: 22, letterSpacing: 0.1);
  static TextStyle get labelMd => subSyncTextStyle(fontSize: 14, fontWeight: regular, lineHeight: 20, letterSpacing: 0.1);
  static TextStyle get labelSm => subSyncTextStyle(fontSize: 12, fontWeight: regular, lineHeight: 16, letterSpacing: 0.1);
  static TextStyle get labelXs => subSyncTextStyle(fontSize: 10, fontWeight: regular, lineHeight: 14, letterSpacing: 0.1);


}

extension PiggyTextTheme on TextTheme{
  TextStyle get displayLg => SubSyncTextStyles.displayLg;
  TextStyle get displayMd => SubSyncTextStyles.displayMd;
  TextStyle get displaySm => SubSyncTextStyles.displaySm;

  TextStyle get heading2xl => SubSyncTextStyles.heading2xl;
  TextStyle get headingXl => SubSyncTextStyles.headingXl;
  TextStyle get headingLg => SubSyncTextStyles.headingLg;
  TextStyle get headingMd => SubSyncTextStyles.headingMd;
  TextStyle get headingSm => SubSyncTextStyles.headingSm;
  TextStyle get headingXs => SubSyncTextStyles.headingXs;

  TextStyle get text2xl => SubSyncTextStyles.text2xl;
  TextStyle get textXl => SubSyncTextStyles.textXl;
  TextStyle get textLg => SubSyncTextStyles.textLg;
  TextStyle get textMd => SubSyncTextStyles.textMd;
  TextStyle get textSm => SubSyncTextStyles.textSm;
  TextStyle get textXs => SubSyncTextStyles.textXs;
  TextStyle get text2xs => SubSyncTextStyles.text2xs;
  
  TextStyle get paragraph2xl => SubSyncTextStyles.paragraph2xl;
  TextStyle get paragraphXl => SubSyncTextStyles.paragraphXl;
  TextStyle get paragraphLg => SubSyncTextStyles.paragraphLg;
  TextStyle get paragraphMd => SubSyncTextStyles.paragraphMd;
  TextStyle get paragraphSm => SubSyncTextStyles.paragraphSm;
  TextStyle get paragraphXs => SubSyncTextStyles.paragraphXs;

  TextStyle get label2xl => SubSyncTextStyles.label2xl ;
  TextStyle get labelXl => SubSyncTextStyles.labelLg;
  TextStyle get labelLg => SubSyncTextStyles.labelLg;
  TextStyle get labelMd => SubSyncTextStyles.labelMd;
  TextStyle get labelSm => SubSyncTextStyles.labelSm;
  TextStyle get labelXs => SubSyncTextStyles.labelXs;


}

TextStyle subSyncTextStyle ({
  
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? lineHeight,
  double? letterSpacing

}){
  Color textColor = themeBloc.isDarkMode ? Colors.white : Colors.black;

 if(lineHeight != null && fontSize != null) {
   height = lineHeight / fontSize;
 }

 return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: textColor,
    letterSpacing: letterSpacing,
    height: height
  ); 
}