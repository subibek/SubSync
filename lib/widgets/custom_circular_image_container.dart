import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';

class CustomCircularImageContainer extends StatelessWidget {
  CustomCircularImageContainer({
    super.key, 
    this.height,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.decorationImage,
    required this.isChildEmpty,
    this.iconPath,
    this.child
  });

  double? height;
  Color? backgroundColor;
  Color? iconColor;
  EdgeInsets? padding;
  DecorationImage? decorationImage;
  bool isChildEmpty;
  String? iconPath;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height ?? 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0),
        image: decorationImage
      ),
      child: child ?? AspectRatio(
        aspectRatio: 1,
        child: Padding(padding:  padding ?? const EdgeInsets.all(12), 
        child: 
          isChildEmpty 
            ? const SizedBox.shrink() 
            : Image(image: AssetImage(iconPath!))
        )//SvgPicture.asset(iconPath!, colorFilter: ColorFilter.mode( iconColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray0 : SubSyncColors.gray80), BlendMode.srcIn),)),
      ),
    );
  }
}