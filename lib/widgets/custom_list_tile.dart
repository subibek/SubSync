import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.onTap,
    required this.child,
    this.color
  });

  GestureTapCallback onTap;
  Widget child;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: 
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color ?? (themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}