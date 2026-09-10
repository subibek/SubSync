import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_screen_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState(){
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                      color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray10
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 44,
                        child: TabBar(
                          controller: tabController,
                          indicator: BoxDecoration(
                            color: themeBloc.isDarkMode ? SubSyncColors.gray70 : Colors.white,
                            borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull)
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerHeight: 0,
                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                          labelStyle: Theme.of(context).textTheme.textSm
                          .copyWith(fontWeight: SubSyncTextStyles.semiBold),
                          unselectedLabelStyle: Theme.of(context).textTheme.textSm
                          .copyWith(fontWeight: SubSyncTextStyles.semiBold, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                          tabs: const [
                            Tab(text: 'Unread'), 
                            Tab(text: 'Read')
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBarView(
                controller: tabController,
                children: [
                  _buildUnreadTabBarView(),
                  _buildReadTabBarView(),
                ] 
              ),
        ),
      )
    );
  }

    Widget _buildReadTabBarView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          _buildTodaySection(), 
          const SizedBox(height: 24),
          _buildEarlierSection(),
        ],
      ),
    );
  }

  Column _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleText('Today'),
        const SizedBox(height: 13),
        _buildNotificationTile(
          iconPath: 'assets/icons/Bell_Outlined.svg', 
          title: 'New Site Assigned', 
          titleTrailing: '1h ago', 
          child: Text(
            'You have been asigned a new site. Click for more details.'
          )
        )
      ],
    );
  }

  Column _buildEarlierSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleText('Earlier'),
        const SizedBox(height: 13),
        _buildNotificationTile(
          iconPath: 'assets/icons/Bell_Outlined.svg', 
          title: '4 sites completed this month', 
          titleTrailing: '1h ago', 
          child: Text(
            'Congratulations on successfully completing 4 sites this month.'
          )
        )
      ],
    );
  }

  Text _buildTitleText(String title) {
    return Text(
        title,
        style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.bold),
      );
  }

  Container _buildNotificationTile({
    required String iconPath,
    required String title,
    required String titleTrailing,
    required Widget child
  }) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusXl),
          color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationTileIcon(iconPath: iconPath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                      title,
                      style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.semiBold),
                    ),
                    Text(
                      titleTrailing,
                      style: Theme.of(context).textTheme.paragraphSm.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                    ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    child
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

  Container _buildNotificationTileIcon({required String iconPath}) {
    return Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeBloc.isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray10
              ),
              child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset(iconPath, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn))),
            );
  }

    Widget _buildUnreadTabBarView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1.417,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: SvgPicture.asset( themeBloc.isDarkMode ? 'assets/images/Useful_tips_2_(Dark).svg' : 'assets/images/Useful_tips_2_(Light).svg' ))
        ),
        const SizedBox(height: 32),
        Text(
          "You're all caught up.",
          style: Theme.of(context).textTheme.headingXs.copyWith(fontWeight: SubSyncTextStyles.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'There are no new notifications to show. Pull down to refresh the list.',
          style: Theme.of(context).textTheme.paragraphMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomButton(
            height: 32,
            width: 139,
            onTap: (){}, 
            outlinedBorder: true, 
            outlineBorderColor: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SvgPicture.asset('assets/icons/ArrowUp.svg', width: 16, fit: BoxFit.scaleDown, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60 , BlendMode.srcIn)),
                const SizedBox(width: 6),
                Text(
                  'Pull to refresh',
                  style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.semiBold, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                ),
              ],
            ),
          )
      ],
    );
  }

    CustomScreenAppBar _buildAppBar() {
    return CustomScreenAppBar(
          title: 'Notifications', 
          trailing: Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/avatars/avatar-39.png')),
            ),
          ), 
        );
  }
}