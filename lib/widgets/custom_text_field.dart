

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';

class CustomTextField extends StatefulWidget {


  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? label;
  final String hintText;
  final String? prefixIcon;
  final String? activeSuffixIcon;
  final String? disabledSuffixIcon;
  final Color? suffixIconColor;
  final Widget? prefixWidget;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final EdgeInsets? contentPadding;
  final bool? enabled;

  final bool? obscureText;


  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.label,
    this.contentPadding,
    required this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.activeSuffixIcon,
    this.disabledSuffixIcon,
    this.suffixIconColor,
    this.obscureText,
    this.validator,
    this.onChanged,
    this.enabled
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isObscureText = false;
  String suffixIcon = '';

  @override
  void initState() {
    if(widget.obscureText != null) isObscureText = widget.obscureText!;
    if(widget.activeSuffixIcon != null) suffixIcon = isObscureText ? widget.activeSuffixIcon! : widget.disabledSuffixIcon!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.label != null) Text(
            widget.label!,
             style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.semiBold),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: TextFormField(
              keyboardType: widget.keyboardType,
              controller: widget.controller,
              validator: widget.validator,
              onChanged: widget.onChanged,
              obscureText: isObscureText,
              maxLines: 1,
              enabled: widget.enabled,
              decoration: InputDecoration(
                isDense: true,

                errorMaxLines: 1,
                errorStyle: const TextStyle(fontSize:0, color: Colors.transparent),
                
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.textMd.copyWith(color: SubSyncColors.gray30),
                
                contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                filled: true,
                fillColor: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray20,
            
                prefixIcon: 
                (widget.prefixWidget != null) ? widget.prefixWidget :
                  (widget.prefixIcon != null) ? FractionallySizedBox(heightFactor: 0.5, widthFactor: 0.1, 
                    child: 
                    SvgPicture.asset( 
                      widget.prefixIcon!, 
                      colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),
                    )
                  ) : null,
                
                suffixIcon: (widget.activeSuffixIcon == null) 
                ? const SizedBox.shrink()
                : FractionallySizedBox(heightFactor: 0.5, widthFactor: 0.1, child: 
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isObscureText = !isObscureText;
                        if (widget.disabledSuffixIcon != null){
                          suffixIcon =  isObscureText ? widget.activeSuffixIcon! : widget.disabledSuffixIcon!;
                        }
                      });
                    },
                    child: 
                    (widget.disabledSuffixIcon == null) 
                    ? SvgPicture.asset(
                        suffixIcon , colorFilter: ColorFilter.mode( widget.suffixIconColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray30), BlendMode.srcIn), 
                      )
                    : SvgPicture.asset(
                        suffixIcon , colorFilter: ColorFilter.mode( widget.suffixIconColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray30), BlendMode.srcIn)
                      ),
                    )
                  ),
            
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                  borderSide: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30)
                ),
            
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                  borderSide: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30)
                ),
            
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                  borderSide: const BorderSide(width: 1, color: SubSyncColors.destructive60)
                ),
            
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                  borderSide: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30)
                ),
            
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                  borderSide: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30)
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}