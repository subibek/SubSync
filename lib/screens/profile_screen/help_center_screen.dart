import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_profile_settings_container.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomAppbarBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopTextContent(),
              const SizedBox(height: 24),
              CustomProfileSettingsContainer(
                leadingIconPath: 'assets/icons/Question.svg',
                text: 'FQA Questions',
                textFontWeight: SubSyncTextStyles.bold, 
                subtitle: 'Commonly asked questions from our users.',
                onTap: (){
                  context.push('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.helpCenterScreen}${RouteNames.faqScreen}');
                }, trailingWidget: null, 
              ),

              const SizedBox(height: 8),

              CustomProfileSettingsContainer(
                leadingIconPath: 'assets/icons/ChatsTeardrop.svg',
                text: 'Chat Live Support',
                textFontWeight: SubSyncTextStyles.bold, 
                subtitle: 'Start a conversation with our friendly support team',
                onTap: (){
                }, 
                trailingWidget: null, 
              ),

              const SizedBox(height: 8),

              CustomProfileSettingsContainer(
                leadingIconPath: 'assets/icons/StarFour_Outlined.svg',
                text: 'Leave a feedback',
                textFontWeight: SubSyncTextStyles.bold, 
                subtitle: "Tell us what features you’d like to add and what can we improve overall",
                onTap: (){
                  
                }, trailingWidget: null, 
              ),
            ],
          ),
        ),
      )
    );
  }

  Padding _buildTopTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help Center',
                style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold),
              ),
              const SizedBox(height: 12),
            ],
          ),
    );
  }
}