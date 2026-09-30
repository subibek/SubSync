// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:location/location.dart';
// import 'package:subsync/blocs/theme_bloc.dart';
// import 'package:subsync/services/location_service.dart';
// import 'package:subsync/utils/colors.dart';
// import 'package:subsync/utils/text_theme.dart';
// import 'package:subsync/widgets/custom_button.dart';
// import 'package:subsync/widgets/custom_error_message.dart';

// class PunchScreen extends StatefulWidget {
//   const PunchScreen({super.key});

//   @override
//   State<PunchScreen> createState() => _PunchScreenState();
// }

// class _PunchScreenState extends State<PunchScreen> {

//   String dropdownValue = '';
//   List<DropdownMenuItem> dropdownMenuItems = [];
//   double cicrcularProgressIndicatorValue = 0;
//   bool isCircularProgressCompleted = false;
//   bool showCircularProgressIndicator = false;
//   bool? isClockInSuccess;

//   @override
//   void initState() {
//     initializeDropdownMenuItems();
//     DropdownMenuItem firstItem = dropdownMenuItems.first;
//     dropdownValue = firstItem.value;
    
//     super.initState();
//   }

//   void startCircularProgressIndicator() async {
//     while (!isCircularProgressCompleted){
//       await Future.delayed(const Duration(milliseconds: 20), (){
//         if (mounted) {updateCircularProgressIndicator();}
//       });
//     }
//   }

//   void updateCircularProgressIndicator() {
//     if(cicrcularProgressIndicatorValue < 1){
//       setState(() => cicrcularProgressIndicatorValue += 0.01);
//     }
//     else{
//       setState(() => cicrcularProgressIndicatorValue = 0);
//       startCircularProgressIndicator();
//     }
//   }

//   // loopCircularProgressIndicator(){
//   //   while (showCircularProgressIndicator){
//   //     setState(() {
//   //       Future.delayed(Duration(milliseconds: 1),(){
//   //         cicrcularProgressIndicatorValue >= 1.0 
//   //           ? cicrcularProgressIndicatorValue = 0
//   //           : cicrcularProgressIndicatorValue += 0.25;  
//   //       });
//   //     });
//   //   }
//   // }

//   initializeDropdownMenuItems(){
//     dropdownMenuItems = [
//       DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'PPM', child: Text('Parkway Paradise Mall')),
//       DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'RM', child: Text('Rundle Mall')),
//       DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'AO', child: Text('Adeladide Oval')),
//       DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'HC', child: Text('Hellet Cove')),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
//               const SizedBox(height: 15),
//               Center(
//                 child: Container(
//                   height: 60,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30),
//                     borderRadius: BorderRadius.circular(24)
//                   ),
//                   child: DropdownButton(
//                     isExpanded: true,
//                     value: dropdownValue,
//                     items: dropdownMenuItems,
//                     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                     underline: const SizedBox.shrink(), 
//                     icon: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: SvgPicture.asset('assets/icons/CaretDown.svg', colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),)),
//                     onChanged: (value) {
//                       setState(() => dropdownValue = value);
//                     },
//                     menuWidth: MediaQuery.of(context).size.width * 0.8,
//                     alignment: Alignment.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Stack(
//                 children: [
//                 if (showCircularProgressIndicator) 
//                   AspectRatio(
//                       aspectRatio: 4/4, 
//                       child: 
//                       CircularProgressIndicator(
//                         strokeCap: StrokeCap.round,
//                         value: cicrcularProgressIndicatorValue,
//                         strokeWidth: 8,
//                         color: themeBloc.currentColor,
//                       ) 
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: 
//                         (showCircularProgressIndicator == false)
//                         ? Border.all(color: 
//                         (isClockInSuccess!= null) 
//                         ? isClockInSuccess! ? SubSyncColors.success60 : SubSyncColors.destructive60
//                         : themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray40, 
//                         width: 10)
//                         : Border()
//                       ),
//                       child: AspectRatio(
//                         aspectRatio: 4/4,
//                         child: Center(
//                           child: 
//                           showCircularProgressIndicator 
//                           ? SizedBox.shrink()
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   TimeOfDay.now().format(context),
//                                   style: Theme.of(context).textTheme.textXl.copyWith(fontWeight: SubSyncTextStyles.bold),
//                                 ),
//                                (isClockInSuccess != null) 
//                                ? Text(
//                                    (isClockInSuccess!) ? 'Clocked In' : 'Error trying to clock in',
//                                     style: Theme.of(context).textTheme.text2xl.copyWith(fontWeight: SubSyncTextStyles.bold),
//                                   )
//                                 : SizedBox.shrink()
//                               ],
//                             )
//                         ),
//                       ),
//                     )
//                 ],
//               ),
//               const SizedBox(height: 30),
//               CustomButton(
//                 title: 'Clock In',
//                 onTap: () async {

//                   setState(() {
//                     showCircularProgressIndicator = true;
//                     isCircularProgressCompleted = false;
//                     cicrcularProgressIndicatorValue = 0;
//                   });

//                   startCircularProgressIndicator();

//                   final locationService = LocationService(
//                     siteLatitude: 37.4219983, 
//                     siteLongitude: -122.084, 
//                     allowRadiusMeters: 100
//                   );

//                   final result = await locationService.canClockIn();
//                   if(result == "Allowed") {
//                     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
//                     setState(() {
//                       showCircularProgressIndicator = false;
//                       isCircularProgressCompleted = true;
//                       isClockInSuccess = true;
//                     });
//                   } else {
//                     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
//                     setState(() {
//                       showCircularProgressIndicator = false;
//                       isCircularProgressCompleted = true;
//                       isClockInSuccess = false;
//                     });
//                   }
//                 }, 
//                 outlinedBorder: true
//               ),
//               const SizedBox(height: 10),
//               CustomButton(onTap: (){}, outlinedBorder: true, title: 'Clock Out',)
//             ],
//           ),
//         )
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/services/location_service.dart';
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

  late AnimationController animationController;

  @override
  void initState() {
    initializeDropdownMenuItems();
    DropdownMenuItem firstItem = dropdownMenuItems.first;
    dropdownValue = firstItem.value;
    
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
                                   (isClockInSuccess!) ? 'Clocked In' : 'Error trying to clock in',
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

                  final result = await locationService.canClockIn();
                  if(result == "Allowed") {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                    if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = true;
                    });
                  } else {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                      if(animationController.isAnimating) animationController.stop();
                    setState(() {
                      showCircularProgressIndicator = false;
                      isClockInSuccess = false;
                    });
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