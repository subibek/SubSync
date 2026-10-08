

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';

class CustomBottomModal extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget child;
  final Widget button;
  final EdgeInsetsGeometry? contentPadding;

  const CustomBottomModal({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    required this.button,
    this.contentPadding
  });

  @override
  Widget build(BuildContext context) {
    return 
    IntrinsicHeight(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: themeBloc.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32)),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 5,
                width: 65,
                decoration: BoxDecoration(
                  color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20,
                  borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull)
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.textLg.copyWith(fontWeight: SubSyncTextStyles.bold)),
                          (trailing != null)
                              ? Text(
                                  trailing!,
                                  style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.medium,color: themeBloc.currentColor))
                              : GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Icon(Icons.close, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SafeArea(
                      child: Padding(
                        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 15),
                        child: child),
                    ),
                    const SizedBox(height: 20),
                    button,
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomBottomModal(BuildContext context,
    {
    required String title,
    String? trailing,
    EdgeInsetsGeometry? contentPadding,
    required Widget child,
    required Widget button}) {
  showModalBottomSheet(
    isScrollControlled: true,
    barrierColor:
        themeBloc.isDarkMode ? SubSyncColors.gray90.withValues(alpha: 0.85) : SubSyncColors.gray30,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => CustomBottomModal(
      contentPadding: contentPadding,
      title: title,
      trailing: trailing,
      button: button,
      child: child,
    ),
  );
}
