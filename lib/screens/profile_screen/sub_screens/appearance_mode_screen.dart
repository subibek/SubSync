import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';

class AppearanceModeScreen extends StatefulWidget {
  const AppearanceModeScreen({super.key});

  @override
  State<AppearanceModeScreen> createState() => _AppearanceModeScreenState();
}

class _AppearanceModeScreenState extends State<AppearanceModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomAppbarBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Appearance Mode',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold),
              ),
              const SizedBox(height: 64),
              _buildAppearanceModeSwitch(),
              const SizedBox(height: 64),
              Column(
                children: [
                   Text(
                    'SubSync is ${ themeBloc.isDarkMode ? 'dark' : 'light' } mode',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headingXs,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Toggle the switch to change mode',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.textMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                  ),
                ],
              )
            ],
          ),
        ), 
      )
    );
  }

    Widget _buildAppearanceModeSwitch() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
        border: Border.all(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray20)
      ),
      child: 
      SizedBox(
        width: 164,
        height: 100,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Transform.scale(
                  scale: 3.1,
                  child: Switch(
                    value: themeBloc.isDarkMode, 
                    // activeColor: SubSyncColors.gray70,
                    focusColor: SubSyncColors.gray70,
                    activeTrackColor: SubSyncColors.gray80,
                    inactiveThumbColor: SubSyncColors.gray0,
                    inactiveTrackColor: SubSyncColors.gray20,
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    trackOutlineWidth: const WidgetStatePropertyAll(0),
                    thumbIcon: const WidgetStatePropertyAll(
                      Icon(Icons.circle, size: 24, color: Colors.transparent,)
                    ),
                    onChanged: (value){
                      themeBloc.toggleDarkMode(value);
                    }),
                    
                ),
              ),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/Sun.svg', width: 32, fit: BoxFit.fitWidth, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray60 : themeBloc.currentColor, BlendMode.srcIn)),
                    const SizedBox(width: 30),
                    SvgPicture.asset('assets/icons/Moon.svg', width: 32, fit: BoxFit.fitWidth, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? themeBloc.currentColor : SubSyncColors.gray40, BlendMode.srcIn)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}