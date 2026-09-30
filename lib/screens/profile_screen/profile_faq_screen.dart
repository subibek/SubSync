import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_button.dart';

class ProfileFaqScreen extends StatefulWidget {
  const ProfileFaqScreen({super.key});

  @override
  State<ProfileFaqScreen> createState() => _ProfileFaqScreenState();
}

class _ProfileFaqScreenState extends State<ProfileFaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomAppbarBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildTextContent(),
              const SizedBox(height: 32),
              _buildExpansionTiles(),
              const SizedBox(height: 32),
              CustomButton(
                onTap: (){}, 
                outlinedBorder: false,
                leadingIcon: SvgPicture.asset('assets/icons/Question.svg', width: 20, fit: BoxFit.fitWidth, colorFilter: const ColorFilter.mode(SubSyncColors.gray0, BlendMode.srcIn),),
                title: 'Still need help?',
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: 'Or contact us at ',
                  style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium),
                  children: [
                    TextSpan(
                      text: 'help@subsync.com',
                      recognizer: TapGestureRecognizer()..onTap= (){},
                      style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.bold, color: themeBloc.currentColor, decoration: TextDecoration.underline)
                    )
                  ]
                ), 
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

   Column _buildExpansionTiles() {
    return Column(
      children: [
        _buildCustomExpansionTile(title: 'What Is SubSync?', content: 'SubSync is a centralized operations management system for cleaning businesses, developed as an industry project in partnership with THNZL Services, a commercial cleaning operator.'),
        const SizedBox(height: 8),
        _buildCustomExpansionTile(title: 'Can I make changes to my schedule at any time?', content: 'Schedules are posted by the admin and require you to send an email request to the admin for changes.'),
        const SizedBox(height: 8),
        _buildCustomExpansionTile(title: 'Is my data secure with SunSync?', content: 'SubSync.'),
        const SizedBox(height: 8),
        _buildCustomExpansionTile(title: 'Is it free to use?', content: 'Yes, SubSync is free to use and operate.'),
      ],
    );
  }

    Column _buildTextContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Frequently Asked Questions",
            style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold),
            textAlign: TextAlign.center,  
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Here are our list of FAQs.",
          style: Theme.of(context).textTheme.paragraphMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
        ),
      ],
    );
  }

    Theme _buildCustomExpansionTile({
    required String title,
    required String content
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusXl),
          color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 12),
          title: Row(
            children: [
              SvgPicture.asset('assets/icons/Question.svg', width: 24, fit: BoxFit.fitWidth, colorFilter: ColorFilter.mode( themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.bold),
                ),
              ),
            ],
          ),
          trailing: SvgPicture.asset('assets/icons/CaretDown.svg', width: 24, fit: BoxFit.fitWidth, colorFilter: const ColorFilter.mode(SubSyncColors.gray40, BlendMode.srcIn)),
          expandedAlignment: Alignment.topLeft,
          children: [
            Text(
              content,
              style: Theme.of(context).textTheme.paragraphSm.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
            ),
          ],
        ),
      ),
    );
  }
}