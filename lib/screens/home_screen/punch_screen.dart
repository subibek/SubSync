import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/site_model.dart';
import 'package:subsync/services/location_service.dart';
import 'package:subsync/services/site_service.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_error_message.dart';

class PunchScreen extends StatefulWidget {
  const PunchScreen({super.key});

  @override
  State<PunchScreen> createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen> with SingleTickerProviderStateMixin{

  String dropdownValue = '';
  List<DropdownMenuItem> dropdownMenuItems = [];
  bool isCircularProgressCompleted = false;
  bool showCircularProgressIndicator = false;
  bool? isClockInSuccess;
  String message = '';

  late AnimationController animationController;

  @override
  void initState() {
    initializeDropdownMenuItems();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    super.initState();
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  initializeDropdownMenuItems() async {

    AllSitesModel? allSites = await SiteService.getAllSites();

    if(allSites != null){
      dropdownMenuItems = [];
      for(final site in allSites.data.results)
        {
          dropdownMenuItems.add(DropdownMenuItem(value: site.address, alignment: AlignmentGeometry.center, child: Text(site.name)));
        }
    } else {
      dropdownMenuItems = [
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'Error', child: Text('Failed to load sites.')),
    ];
    }

    setState((){
      DropdownMenuItem firstItem = dropdownMenuItems.first;
      dropdownValue = firstItem.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30),
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownValue,
                    items: dropdownMenuItems,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    underline: const SizedBox.shrink(), 
                    icon: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: SvgPicture.asset('assets/icons/CaretDown.svg', colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),)),
                    onChanged: (value) {
                      setState(() => dropdownValue = value);
                    },
                    menuWidth: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                if (showCircularProgressIndicator) 
                  AspectRatio(
                      aspectRatio: 4/4, 
                      child: 
                      RotationTransition(
                        turns: animationController,
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          value: 0.25,
                          strokeWidth: 8,
                          color: themeBloc.currentColor,
                        ),
                      ) 
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: 
                        (!showCircularProgressIndicator)
                        ? Border.all(
                          width: 10,
                          color: (isClockInSuccess!= null) 
                            ? isClockInSuccess! ? SubSyncColors.success60 : SubSyncColors.destructive60
                            : themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray40
                        )
                        : Border()
                      ),
                      child: AspectRatio(
                        aspectRatio: 4/4,
                        child: Center(
                          child: 
                          showCircularProgressIndicator 
                          ? SizedBox.shrink()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  TimeOfDay.now().format(context),
                                  style: Theme.of(context).textTheme.textXl.copyWith(fontWeight: SubSyncTextStyles.bold),
                                ),
                               (isClockInSuccess != null) 
                               ? Text(
                                   message,
                                   textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.text2xl.copyWith(fontWeight: SubSyncTextStyles.bold),
                                  )
                                : SizedBox.shrink()
                              ],
                            )
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: 'Clock In',
                onTap: () async {
                  animationController.repeat();
                  
                  setState(() => showCircularProgressIndicator = true);
                  
                  final locationService = LocationService(
                    siteLatitude: 37.4219983, 
                    siteLongitude: -122.084, 
                    allowRadiusMeters: 100
                  );

                  final result = await locationService.canClockIn(dropdownValue);
                  if(result == "Success") {
                    if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = true;
                      message = "Clocked in successfully";
                    });
                  } else {
                      if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = false;
                      message = result;
                    });
                  }
                }, 
                outlinedBorder: true
              ),
              const SizedBox(height: 10),
              CustomButton(onTap: () async {
                animationController.repeat();
                  
                  setState(() => showCircularProgressIndicator = true);
                  
                  final locationService = LocationService(
                    siteLatitude: 37.4219983, 
                    siteLongitude: -122.084, 
                    allowRadiusMeters: 100
                  );

                  final result = await locationService.clockOut(dropdownValue,null,null);
                  if(result == "Success") {
                    if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = true;
                      message = "Clocked out successfully";
                    });
                  } else {
                      if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = false;
                      message = result;
                    });
                  }
              }, outlinedBorder: true, title: 'Clock Out',)
            ],
          ),
        )
    );
  }
}