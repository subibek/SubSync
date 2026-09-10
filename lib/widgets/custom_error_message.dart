


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';

class CustomErrorMessage extends StatelessWidget {

  final String content;

  const CustomErrorMessage({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: SubSyncColors.brand90,
          border: Border.all(width: 1, color: SubSyncColors.destructive60)
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(flex: 1, child: SvgPicture.asset('assets/icons/error_info.svg')),
            const SizedBox(width: 10),
            Expanded(flex: 11, child: Text(content, style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.bold)))
          ],
        ),
      );
  }
}