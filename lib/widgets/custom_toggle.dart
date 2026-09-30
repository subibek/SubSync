import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';

class CustomToggle extends StatefulWidget {
  
  final bool value;
  final Function(bool)? onChanged;
  final Color? inactiveTrackColor;
  final Color? inactiveThumbColor;

  const CustomToggle({
    required this.value,
    required this.onChanged,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    super.key
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 28,
      child: Switch(
        value: widget.value, 
        activeColor: SubSyncColors.gray0,
        activeTrackColor: themeBloc.currentColor,
        inactiveTrackColor: widget.inactiveTrackColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray70 :  SubSyncColors.gray20),
        inactiveThumbColor: widget.inactiveThumbColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray0),
        trackOutlineWidth: const WidgetStatePropertyAll(0),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        thumbIcon: const WidgetStatePropertyAll(
          Icon(Icons.circle, size: 16, color: Colors.transparent)
        ),
        onChanged: widget.onChanged
        ),
    );
  }
}