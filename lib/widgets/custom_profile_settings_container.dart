
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';

class CustomProfileSettingsContainer extends StatefulWidget {

  final String? leadingIconPath;
  final String text;
  final String? subtitle;
  final GestureTapCallback onTap;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final EdgeInsets? padding;
  final double? borderRadius;
  final FontWeight? textFontWeight;

  const CustomProfileSettingsContainer({

    this.padding,
    this.borderRadius,
    this.leadingIconPath,
    required this.text,
    this.subtitle,
    required this.onTap,
    this.leadingWidget,
    this.trailingWidget, 
    this.textFontWeight,
    super.key
  });

  @override
  State<CustomProfileSettingsContainer> createState() => _CustomProfileSettingsContainerState();
}

class _CustomProfileSettingsContainerState extends State<CustomProfileSettingsContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
        color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: 0,
            color: const Color(0xff1C191705).withOpacity(0.02)
          ),
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
            color: const Color(0xff1C191705).withOpacity(0.03)
          ),
        ]
      ),        
      child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(16),
          child: Row(
            children: [
              if(widget.leadingWidget != null) widget.leadingWidget!,
              if(widget.leadingWidget == null && widget.leadingIconPath != null) SizedBox(height: 24, child: SvgPicture.asset(widget.leadingIconPath!, width: 24, fit: BoxFit.fitHeight, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn))),
              if (widget.leadingWidget != null || widget.leadingIconPath != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          widget.text,
                          style: TextStyle(fontWeight: widget.textFontWeight ?? FontWeight.bold),
                          // style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: widget.textFontWeight ?? PiggyTextStyles.semiBold),
                        ),
                    if(widget.subtitle != null) const SizedBox(height: 6),
                    if(widget.subtitle != null) Text(
                          widget.subtitle!,
                          style: TextStyle(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                          // style: Theme.of(context).textTheme.paragraphSm.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                        ), 
                  ],
                )
              ),
              (widget.trailingWidget != null) 
                ? Padding(padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0), child: widget.trailingWidget!)
                : SvgPicture.asset('assets/icons/CaretRight.svg', width: 24, fit: BoxFit.scaleDown, colorFilter: const ColorFilter.mode(SubSyncColors.gray40, BlendMode.srcIn))
            ],
          ), 
        ),
      ),
    );
  }
}
