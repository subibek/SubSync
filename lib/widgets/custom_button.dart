


import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';

class CustomButton extends StatelessWidget {

  final GestureTapCallback onTap;
  final Widget? child;
  final bool? isLoading;
  final String? title;
  final TextStyle? titleStyle;
  final bool outlinedBorder;
  final Color? outlineBorderColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? buttonColor;
  final double? height;
  final double? width;
  final Color? splashColor;

  const CustomButton({
    super.key,
    required this.onTap,
    this.child,
    required this.outlinedBorder,
    this.outlineBorderColor,
    this.title,
    this.titleStyle,
    this.isLoading,
    this.leadingIcon,
    this.trailingIcon,
    this.buttonColor,
    this.height,
    this.width,
    this.splashColor
  });

  @override
  Widget build(BuildContext context) {

    double borderRadius = 24;

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      splashColor: splashColor ?? themeBloc.currentColor.withValues(alpha: 0.4),
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width,
        decoration:
        (!outlinedBorder) 
        ? BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColor ?? themeBloc.currentColor,
        )
        : BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(width: 1, color: outlineBorderColor ?? themeBloc.currentColor),
        ),
        child: (child != null) 
        ? child 
        : (title != null) 
          ? (isLoading != null && isLoading == true) 
              ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ) 
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(leadingIcon != null)
                Row(children: [
                  leadingIcon!,
                  const SizedBox(width: 10),                  
                ],), 
              Text(
                title!,
                style: 
                titleStyle ?? Theme.of(context).textTheme.textMd.copyWith(
                  fontWeight: SubSyncTextStyles.semiBold,
                  color: outlinedBorder ? themeBloc.currentColor : Colors.white 
                )
              ),
              if(trailingIcon != null)
                Row(children: [
                  const SizedBox(width: 10),
                  trailingIcon!
                  
                ],) 
            ],
          )
        : const Text('Both child and title empty. Return atlease one.')
      ),
    );
  }
}