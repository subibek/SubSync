
import 'package:flutter/material.dart';
import 'package:subsync/utils/colors.dart';

class CustomTextButton extends StatelessWidget {

  final GestureTapCallback onTap;
  final String content;
  final bool underline;
  final TextStyle? style;
  final Widget? trailingIcon;
  final MainAxisAlignment? mainAxisAlignment;
  
  const CustomTextButton({
    super.key,
    required this.content,
    required this.onTap,
    required this.underline,
    this.style,
    this.trailingIcon,
    this.mainAxisAlignment
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Text(
            content,
            style: 
            style ??
            TextStyle(
              fontWeight: FontWeight.bold,
              color: SubSyncColors.brand40,
              decoration: underline? TextDecoration.underline : null,
              decorationColor: SubSyncColors.brand80
            ),
          ),
          const SizedBox(width: 8),
          if(trailingIcon != null) trailingIcon!
        ],
      ),
    );
  }
}