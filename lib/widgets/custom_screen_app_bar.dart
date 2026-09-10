import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';

class CustomScreenAppBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final String? trailingIcon;
  final GestureTapCallback? onTap;

  const CustomScreenAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.trailingIcon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
       floating: true,
      //forceMaterialTransparency: true,
      leadingWidth: 60 ,
      title: Text(
        title,
        style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.semiBold),
        ),
      centerTitle: true,
      leading: 
      const CustomAppbarBackButton(),
      actions: [
        (trailing != null) 
        ? trailing!
        : (trailingIcon != null) 
            ? GestureDetector(
              onTap: onTap,
              child: ImageIcon(AssetImage(trailingIcon!), color: themeBloc.isDarkMode ? Colors.white : SubSyncColors.gray80 ,)
            )
            : const SizedBox.shrink(),
        const SizedBox(width: 15)
      ],
    );
  }
}

