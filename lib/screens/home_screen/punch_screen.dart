import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/services/location_service.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_error_message.dart';

class PunchScreen extends StatefulWidget {
  const PunchScreen({super.key});

  @override
  State<PunchScreen> createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen> {

  String dropdownValue = '';
  List<DropdownMenuItem> dropdownMenuItems = [];
  double cicrcularProgressIndicatorValue = 0;
  bool showCircularProgressIndicator = false;

  @override
  void initState() {
    initializeDropdownMenuItems();
    DropdownMenuItem firstItem = dropdownMenuItems.first;
    dropdownValue = firstItem.value;
    
    super.initState();
  }

  loopCircularProgressIndicator(){
    while (showCircularProgressIndicator){
      setState(() {
        Future.delayed(Duration(milliseconds: 1),(){
          cicrcularProgressIndicatorValue >= 1.0 
            ? cicrcularProgressIndicatorValue = 0
            : cicrcularProgressIndicatorValue += 0.25;  
        });
      });
    }
  }

  initializeDropdownMenuItems(){
    dropdownMenuItems = [
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'PPM', child: Text('Parkway Paradise Mall')),
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'RM', child: Text('Rundle Mall')),
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'AO', child: Text('Adeladide Oval')),
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'HC', child: Text('Hellet Cove')),
    ];
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
              const SizedBox(height: 20),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4/4, 
                    child: CircularProgressIndicator(
                      value: cicrcularProgressIndicatorValue,
                      strokeWidth: 6,
                      color: themeBloc.currentColor,
                    )
                  )
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: 'Clock In',
                onTap: () async {

                  setState(() => showCircularProgressIndicator = true);

                  final locationService = LocationService(
                    siteLatitude: 37.4219983, 
                    siteLongitude: -122.084, 
                    allowRadiusMeters: 100
                  );

                  final result = await locationService.canClockIn();
                  if(result == "Allowed") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                }, 
                outlinedBorder: true
              ),
              const SizedBox(height: 10),
              CustomButton(onTap: (){}, outlinedBorder: true, title: 'Clock Out',)
            ],
          ),
        )
    );
  }
}