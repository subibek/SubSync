import 'package:flutter/material.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_profile_settings_container.dart';
import 'package:subsync/widgets/custom_toggle.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
 
  bool isPushNotifications = true;
  bool isEmailNotifications = false;
  bool isTransactionStatus = true;
  bool isEmailReminder = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [ 
            const SliverAppBar(
              leading: CustomAppbarBackButton(),
            )
          ];
        } , 
        body: 
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopTextContent(),
                  const SizedBox(height: 24),
                  buildSections(title: 'General', child: _buildGeneralSectionContent()),
                  const SizedBox(height: 44),
                ],
              ),
            ),
        ),
        ),
    );
  }

    Column buildSections({
    required String title,
    required Widget child
  }) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                style: Theme.of(context).textTheme.textMd.copyWith(fontWeight:  SubSyncTextStyles.bold),
              ),
              const SizedBox(height: 12),
              child
            ],
          );
  }

  Padding _buildTopTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification Settings',
                style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Turn on notification to never miss an update.',
                style: Theme.of(context).textTheme.paragraphMd
              ),
            ],
          ),
    );
  }

  Column _buildGeneralSectionContent() {
    return Column(
      children: [
        CustomProfileSettingsContainer(
        leadingIconPath: 'assets/icons/Question.svg', 
        borderRadius: 20, 
        text: 'Push Notifications', 
        textFontWeight: SubSyncTextStyles.bold,
        subtitle: 'Turn on to get notified on your mobile device.', 
        onTap: (){},
        trailingWidget: CustomToggle(
          value: isPushNotifications,
          onChanged: (value){
            setState(() => isPushNotifications = value);
          }
        ),
      ),
      const SizedBox(height: 12),
      CustomProfileSettingsContainer(
        text: 'Email Notifications', 
        textFontWeight: SubSyncTextStyles.bold,
        borderRadius: 20, 
        subtitle: 'Get notified via you email address.', 
        onTap: (){},
        trailingWidget: CustomToggle(
          value: isEmailNotifications,
          onChanged: (value){
            setState(() => isEmailNotifications = value);
          }
        ),
      ),
      // const SizedBox(height: 12),
      // CustomProfileSettingsContainer(
      //   text: 'Transaction Status', 
      //   textFontWeight: SubSyncTextStyles.bold,
      //   borderRadius: 20, 
      //   onTap: (){},
      //   trailingWidget: CustomToggle(
      //     value: isTransactionStatus,
      //     onChanged: (value){
      //       setState(() => isTransactionStatus = value);
      //     }
      //   ),
      // ),
      const SizedBox(height: 12),CustomProfileSettingsContainer(
        text: 'Email Reminder', 
        textFontWeight: SubSyncTextStyles.bold,
        borderRadius: 20, 
        subtitle: 'Send task and deadline reminders via your emails', 
        onTap: (){},
        trailingWidget: CustomToggle(
          value: isEmailReminder,
          onChanged: (value){
            setState(() => isEmailReminder = value);
          }
        ),
      ),
      ],
    );
  }
}